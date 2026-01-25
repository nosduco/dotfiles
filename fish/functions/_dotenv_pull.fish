function _dotenv_pull --description "Pull .env from Bitwarden to local"
    # Parse arguments
    set -l force 0
    for arg in $argv
        switch $arg
            case --force -f
                set force 1
            case '*'
                echo "dotenv pull: unknown option '$arg'" >&2
                return 1
        end
    end

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

    # Find the item
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
        # Fallback: extract notes with string matching
        set remote_content (echo "$item_json" | string match -r '"notes":"([^"]*)"' | tail -1 | string replace -a '\\n' \n | string replace -a '\\"' '"' | string replace -a '\\\\' '\\')
    end

    # Check if local .env exists and differs
    if test -f "$env_file"
        set -l local_content (cat "$env_file")

        if test "$local_content" != "$remote_content"
            if test $force -eq 0
                echo "dotenv: local .env differs from remote" >&2
                echo "" >&2

                # Show diff (local vs remote)
                set -l tmpfile (mktemp)
                echo "$remote_content" > "$tmpfile"

                if command -q delta
                    delta "$env_file" "$tmpfile" --file-modified-label "local" --file-modified-label "remote"
                else
                    diff --color=auto -u "$env_file" "$tmpfile" | head -50
                end

                rm -f "$tmpfile"

                echo "" >&2
                echo "Use 'dotenv pull --force' to overwrite local changes" >&2
                return 1
            end
        else
            echo "dotenv: local .env is already up to date"
            return 0
        end
    end

    # Write the remote content to local .env
    echo "$remote_content" > "$env_file"
    echo "dotenv: pulled $item_name to .env"
    return 0
end
