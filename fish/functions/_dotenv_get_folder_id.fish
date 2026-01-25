function _dotenv_get_folder_id --description "Get or create the dotenv folder in Bitwarden"
    set -l folder_name "dotenv"

    # Try to find existing folder
    set -l folders_json (bw list folders 2>/dev/null)
    if test $status -ne 0
        echo "dotenv: failed to list folders" >&2
        return 1
    end

    # Parse folder ID from JSON - look for folder named "dotenv"
    set -l folder_id (echo "$folders_json" | string match -r '"id":"([^"]+)"[^}]*"name":"dotenv"' | tail -1)

    if test -n "$folder_id"
        echo "$folder_id"
        return 0
    end

    # Folder doesn't exist, create it
    set -l create_json (printf '{"name":"%s"}' "$folder_name")
    set -l encoded (echo "$create_json" | bw encode)
    set -l result (bw create folder "$encoded" 2>/dev/null)

    if test $status -ne 0
        echo "dotenv: failed to create folder" >&2
        return 1
    end

    # Extract ID from created folder
    set folder_id (echo "$result" | string match -r '"id":"([^"]+)"' | tail -1)

    if test -z "$folder_id"
        echo "dotenv: failed to parse folder id" >&2
        return 1
    end

    echo "$folder_id"
    return 0
end
