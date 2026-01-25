function _dotenv_list --description "List all stored env items in Bitwarden"
    # Ensure session is active
    _dotenv_ensure_session
    or return 1

    # Sync to get latest
    bw sync >/dev/null 2>&1

    # Search for all env:: items
    set -l items_json (bw list items --search "env::" 2>/dev/null)
    if test $status -ne 0
        echo "dotenv: failed to list items" >&2
        return 1
    end

    # Parse and display items
    if command -q jq
        set -l count (echo "$items_json" | jq 'length')

        if test "$count" = "0"
            echo "dotenv: no stored environments found"
            return 0
        end

        echo "Stored environments:"
        echo ""

        # Output formatted list with name and revision date
        echo "$items_json" | jq -r '.[] | select(.name | startswith("env::")) | "\(.name)\t\(.revisionDate // "unknown")"' | while read -l line
            set -l name (echo "$line" | cut -f1)
            set -l date (echo "$line" | cut -f2)

            # Format the date if possible
            if test "$date" != "unknown"
                set date (echo "$date" | string replace -r 'T.*' '' )
            end

            # Extract project name from env::name
            set -l project (string replace 'env::' '' "$name")

            printf "  %-40s %s\n" "$project" "$date"
        end
    else
        # Fallback without jq - basic parsing
        set -l names (echo "$items_json" | string match -ra '"name":"(env::[^"]+)"' | string replace '"name":"' '' | string replace '"' '')

        if test (count $names) -eq 0
            echo "dotenv: no stored environments found"
            return 0
        end

        echo "Stored environments:"
        echo ""

        for name in $names
            set -l project (string replace 'env::' '' "$name")
            echo "  $project"
        end
    end

    return 0
end
