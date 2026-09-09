# Completions for dotenv command

# Disable file completions by default
complete -c dotenv -f

# Subcommands
complete -c dotenv -n "not __fish_seen_subcommand_from pull push diff list id" -a pull -d "Pull .env from Bitwarden to local"
complete -c dotenv -n "not __fish_seen_subcommand_from pull push diff list id" -a push -d "Push local .env to Bitwarden"
complete -c dotenv -n "not __fish_seen_subcommand_from pull push diff list id" -a diff -d "Show diff between local and remote"
complete -c dotenv -n "not __fish_seen_subcommand_from pull push diff list id" -a list -d "List all stored env items"
complete -c dotenv -n "not __fish_seen_subcommand_from pull push diff list id" -a id -d "Print resolved project identifier"

# Pull options
complete -c dotenv -n "__fish_seen_subcommand_from pull" -l force -d "Overwrite local .env without confirmation"

# Help
complete -c dotenv -s h -l help -d "Show help message"
