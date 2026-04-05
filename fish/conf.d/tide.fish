# Tide prompt configuration (replaces Starship)
# Matches Starship look: directory (user@host) on  branch [status]
# with character on second line

# Prompt style: lean (no powerline segments, just colored text)
set -g tide_left_prompt_items pwd context git node python go rustc java docker kubectl terraform aws newline character
set -g tide_right_prompt_items status cmd_duration jobs

# Don't spread items across full width
set -g tide_prompt_pad_items false

# Newline before prompt
set -g tide_prompt_add_newline_before true

# No frames
set -g tide_left_prompt_frame_enabled false
set -g tide_right_prompt_frame_enabled false

# Tight separators (lean style - all bg is normal)
set -g tide_left_prompt_separator_diff_color ' '
set -g tide_left_prompt_separator_same_color ' '
set -g tide_left_prompt_prefix ''
set -g tide_left_prompt_suffix ''

# Character (matches Starship bold orange)
set -g tide_character_icon '❯'
set -g tide_character_vi_icon_default '❮'
set -g tide_character_vi_icon_replace '❮'
set -g tide_character_vi_icon_visual '❮'
set -g tide_character_color fab387
set -g tide_character_color_failure f38ba8

# PWD (yellow, matching Starship directory - anchors are bold automatically)
set -g tide_pwd_bg_color normal
set -g tide_pwd_color_dirs f9e2af
set -g tide_pwd_color_anchors f9e2af
set -g tide_pwd_color_truncated_dirs 9a8866
set -g tide_pwd_markers .git .hg .svn package.json Cargo.toml go.mod pyproject.toml
set -g tide_pwd_icon \x1d
set -g tide_pwd_icon_home \x1d
set -g tide_pwd_icon_unwritable \x1d

# Context (user@host - always shown, bold red, matching Starship)
set -g tide_context_bg_color normal
set -g tide_context_always_display true
set -g tide_context_color_default f38ba8
set -g tide_context_color_root a6e3a1
set -g tide_context_color_ssh f38ba8
set -g tide_context_hostname_parts 1

# Git (matching Starship: bold purple/mauve branch, red status)
set -g tide_git_bg_color normal
set -g tide_git_bg_color_unstable normal
set -g tide_git_bg_color_urgent normal
set -g tide_git_icon ' '
set -g tide_git_color_branch cba6f7
set -g tide_git_color_dirty f9e2af
set -g tide_git_color_operation f38ba8
set -g tide_git_color_staged a6e3a1
set -g tide_git_color_stash a6e3a1
set -g tide_git_color_conflicted f38ba8
set -g tide_git_color_untracked 89b4fa
set -g tide_git_color_upstream 89b4fa
set -g tide_git_truncation_length 24
set -g tide_git_truncation_strategy ''

# Status
set -g tide_status_bg_color normal
set -g tide_status_bg_color_failure normal
set -g tide_status_color a6e3a1
set -g tide_status_color_failure f38ba8
set -g tide_status_icon '✔'
set -g tide_status_icon_failure '✘'

# Cmd duration (threshold 2s to match Starship default)
set -g tide_cmd_duration_bg_color normal
set -g tide_cmd_duration_color 6c7086
set -g tide_cmd_duration_threshold 2000
set -g tide_cmd_duration_decimals 0
set -g tide_cmd_duration_icon ''

# Jobs
set -g tide_jobs_bg_color normal
set -g tide_jobs_color 89dceb
set -g tide_jobs_icon '✦'
set -g tide_jobs_number_threshold 1000

# Tool colors (Catppuccin Mocha)
set -g tide_node_bg_color normal
set -g tide_node_icon ' '
set -g tide_node_color a6e3a1
set -g tide_python_bg_color normal
set -g tide_python_icon '󰌠 '
set -g tide_python_color f9e2af
set -g tide_go_bg_color normal
set -g tide_go_icon ' '
set -g tide_go_color 74c7ec
set -g tide_rustc_bg_color normal
set -g tide_rustc_icon ' '
set -g tide_rustc_color fab387
set -g tide_java_bg_color normal
set -g tide_java_icon ' '
set -g tide_java_color f38ba8
set -g tide_docker_bg_color normal
set -g tide_docker_icon '󰡨 '
set -g tide_docker_color 89b4fa
set -g tide_docker_default_contexts default colima
set -g tide_kubectl_bg_color normal
set -g tide_kubectl_icon '󱃾 '
set -g tide_kubectl_color 89dceb
set -g tide_terraform_bg_color normal
set -g tide_terraform_icon '󱁢 '
set -g tide_terraform_color cba6f7
set -g tide_aws_bg_color normal
set -g tide_aws_icon '☁ '
set -g tide_aws_color f9e2af

# Right prompt separators
set -g tide_right_prompt_separator_diff_color ' '
set -g tide_right_prompt_separator_same_color ' '
set -g tide_right_prompt_prefix ''
set -g tide_right_prompt_suffix ''

# Prompt connection/frame colors (not used in lean but required)
set -g tide_prompt_color_frame_and_connection 6c7086
set -g tide_prompt_color_separator_same_color 6c7086
set -g tide_prompt_icon_connection ' '
set -g tide_prompt_min_cols 34

# Disable transient prompt
set -g tide_prompt_transient_enabled false
