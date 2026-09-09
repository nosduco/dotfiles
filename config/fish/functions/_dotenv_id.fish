function _dotenv_id --description "Print resolved project identifier"
    set -l project_id (_dotenv_resolve_id)
    if test $status -ne 0
        return 1
    end

    echo "$project_id"
    return 0
end
