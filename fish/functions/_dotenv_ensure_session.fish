function _dotenv_ensure_session --description "Ensure Bitwarden session is active"
    # Check current vault status
    set -l status_json (bw status 2>/dev/null)
    if test $status -ne 0
        echo "dotenv: failed to get bitwarden status" >&2
        return 1
    end

    set -l vault_status (echo "$status_json" | string match -r '"status":"([^"]+)"' | tail -1)

    switch "$vault_status"
        case unauthenticated
            echo "dotenv: not logged in to bitwarden - run 'bw login' first" >&2
            return 1

        case locked
            # Prompt for unlock - let stderr through for password prompt
            echo "dotenv: vault is locked, unlocking..." >&2
            set -l session (bw unlock --raw)
            if test $status -ne 0 -o -z "$session"
                echo "dotenv: failed to unlock vault" >&2
                return 1
            end
            set -gx BW_SESSION "$session"
            echo "dotenv: vault unlocked" >&2
            return 0

        case unlocked
            # Already unlocked - BW_SESSION should be set in environment
            # If not set, bw commands will still work if vault is unlocked
            return 0

        case '*'
            echo "dotenv: unknown vault status: $vault_status" >&2
            return 1
    end
end
