function _dotenv_resolve_id --description "Resolve project identifier for dotenv"
    # Get git root, fail if not in a git repo
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    if test $status -ne 0
        echo "dotenv: not in a git repository" >&2
        return 1
    end

    # Priority 1: Check for .envrc-id file
    set -l envrc_id_file "$git_root/.envrc-id"
    if test -f "$envrc_id_file"
        set -l custom_id (string trim < "$envrc_id_file")
        if test -n "$custom_id"
            echo "$custom_id"
            return 0
        end
    end

    # Priority 2: Parse git remote origin
    set -l remote_url (git remote get-url origin 2>/dev/null)
    if test -n "$remote_url"
        # Handle SSH format: git@github.com:org/repo.git
        if string match -q 'git@*' "$remote_url"
            set -l parsed (string replace -r '^git@[^:]+:(.+?)(?:\.git)?$' '$1' "$remote_url")
            if test -n "$parsed"
                echo "$parsed"
                return 0
            end
        end

        # Handle HTTPS format: https://github.com/org/repo.git
        if string match -q 'https://*' "$remote_url"
            set -l parsed (string replace -r '^https://[^/]+/(.+?)(?:\.git)?$' '$1' "$remote_url")
            if test -n "$parsed"
                echo "$parsed"
                return 0
            end
        end
    end

    # Priority 3: Fallback to git root directory name
    echo (basename "$git_root")
    return 0
end
