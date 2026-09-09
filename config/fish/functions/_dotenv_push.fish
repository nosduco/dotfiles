function _dotenv_push --description "Push local .env to Bitwarden"
    # Ensure session is active
    _dotenv_ensure_session
    or return 1

    # Resolve project ID
    set -l project_id (_dotenv_resolve_id)
    or return 1

    set -l item_name "env::$project_id"

    # Get git root for .env location
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    set -l env_file "$git_root/.env"

    # Check if local .env exists
    if not test -f "$env_file"
        echo "dotenv: no .env file found at $env_file" >&2
        return 1
    end

    # Read .env content - use string collect to preserve newlines
    set -l env_content (cat "$env_file" | string collect)

    # Warn if empty but proceed
    if test -z "$env_content"
        echo "dotenv: warning - .env file is empty" >&2
    end

    # Get folder ID (creates if needed)
    set -l folder_id (_dotenv_get_folder_id)
    or return 1

    # Check if item already exists
    set -l existing_item (bw list items --search "$item_name" 2>/dev/null | string match -r '"id":"([^"]+)"[^}]*"name":"'(string escape --style=regex "$item_name")'"' | tail -1)

    if test -n "$existing_item"
        # Update existing item
        set -l item_id "$existing_item"

        # Get full item JSON
        set -l item_json (bw get item "$item_id" 2>/dev/null)
        if test $status -ne 0
            echo "dotenv: failed to get existing item" >&2
            return 1
        end

        # Update the notes field with new content
        # Use jq if available, otherwise use string replacement
        if command -q jq
            set -l updated_json (echo "$item_json" | jq --arg notes "$env_content" '.notes = $notes')
            set -l encoded (echo "$updated_json" | bw encode)
            bw edit item "$item_id" "$encoded" >/dev/null 2>&1
        else
            # Fallback: escape content and use string replacement
            set -l escaped_content (echo "$env_content" | string replace -a '\\' '\\\\' | string replace -a '"' '\\"' | string replace -a \n '\\n')
            set -l updated_json (echo "$item_json" | string replace -r '"notes":"[^"]*"' "\"notes\":\"$escaped_content\"")
            set -l encoded (echo "$updated_json" | bw encode)
            bw edit item "$item_id" "$encoded" >/dev/null 2>&1
        end

        if test $status -ne 0
            echo "dotenv: failed to update item" >&2
            return 1
        end

        echo "dotenv: updated $item_name"
    else
        # Create new secure note
        # Type 2 = Secure Note
        if command -q jq
            set -l item_json (jq -n \
                --arg name "$item_name" \
                --arg notes "$env_content" \
                --arg folder "$folder_id" \
                '{type: 2, secureNote: {type: 0}, name: $name, notes: $notes, folderId: $folder}')
            set -l encoded (echo "$item_json" | bw encode)
            bw create item "$encoded" >/dev/null 2>&1
        else
            # Fallback without jq
            set -l escaped_content (echo "$env_content" | string replace -a '\\' '\\\\' | string replace -a '"' '\\"' | string replace -a \n '\\n')
            set -l item_json "{\"type\":2,\"secureNote\":{\"type\":0},\"name\":\"$item_name\",\"notes\":\"$escaped_content\",\"folderId\":\"$folder_id\"}"
            set -l encoded (echo "$item_json" | bw encode)
            bw create item "$encoded" >/dev/null 2>&1
        end

        if test $status -ne 0
            echo "dotenv: failed to create item" >&2
            return 1
        end

        echo "dotenv: created $item_name"
    end

    # Sync to ensure server has latest
    bw sync >/dev/null 2>&1

    return 0
end
