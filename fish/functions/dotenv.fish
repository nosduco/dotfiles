function dotenv --description "Sync .env files with Bitwarden"
    # Check for bw CLI
    if not command -q bw
        echo "dotenv: bitwarden CLI (bw) not found" >&2
        return 1
    end

    # Dispatch to subcommand
    switch $argv[1]
        case pull
            _dotenv_pull $argv[2..-1]
        case push
            _dotenv_push $argv[2..-1]
        case diff
            _dotenv_diff $argv[2..-1]
        case list
            _dotenv_list $argv[2..-1]
        case id
            _dotenv_id $argv[2..-1]
        case -h --help ''
            _dotenv_help
        case '*'
            echo "dotenv: unknown command '$argv[1]'" >&2
            echo "Run 'dotenv --help' for usage" >&2
            return 1
    end
end

function _dotenv_help --description "Print dotenv help"
    echo "Usage: dotenv <command> [options]"
    echo ""
    echo "Sync .env files with Bitwarden secure notes."
    echo ""
    echo "Commands:"
    echo "  pull [--force]  Pull .env from Bitwarden to local"
    echo "  push            Push local .env to Bitwarden"
    echo "  diff            Show diff between local and remote"
    echo "  list            List all stored env items"
    echo "  id              Print resolved project identifier"
    echo ""
    echo "Project ID Resolution (in priority order):"
    echo "  1. .envrc-id file in git root (custom override)"
    echo "  2. Git remote origin parsed to org/repo"
    echo "  3. Git root directory name (fallback)"
    echo ""
    echo "Items are stored as secure notes named 'env::{project-id}'"
    echo "in a folder named 'dotenv'."
end
