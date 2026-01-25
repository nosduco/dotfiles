function _dotenv_diff --description "Show diff between local and remote .env"
    # Ensure session is active
    _dotenv_ensure_session
    or return 1

    # Sync to get latest
    bw sync >/dev/null 2>&1

    # Resolve project ID
    set -l project_id (_dotenv_resolve_id)
    or return 1

    set -l item_name "env::$project_id"

    # Get git root for .env location
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    set -l env_file "$git_root/.env"

    # Check if local .env exists
    if not test -f "$env_file"
        echo "dotenv: no local .env file found" >&2
        return 1
    end

    # Find the remote item
    set -l item_json (bw get item "$item_name" 2>/dev/null)
    if test $status -ne 0
        echo "dotenv: no remote env found for '$project_id'" >&2
        echo "Run 'dotenv push' first to create it" >&2
        return 1
    end

    # Extract notes field (the .env content)
    set -l remote_content
    if command -q jq
        set remote_content (echo "$item_json" | jq -r '.notes // empty')
    else
        set remote_content (echo "$item_json" | string match -r '"notes":"([^"]*)"' | tail -1 | string replace -a '\\n' \n | string replace -a '\\"' '"' | string replace -a '\\\\' '\\')
    end

    set -l local_content (cat "$env_file")

    # Compare
    if test "$local_content" = "$remote_content"
        echo "dotenv: local and remote are identical"
        return 0
    end

    # Show diff
    set -l tmpfile (mktemp)
    echo "$remote_content" > "$tmpfile"

    echo "--- local: $env_file"
    echo "+++ remote: $item_name"
    echo ""

    if command -q delta
        delta "$env_file" "$tmpfile"
    else
        diff --color=auto -u "$env_file" "$tmpfile"
    end

    rm -f "$tmpfile"
    return 0
end
