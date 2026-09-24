{
  colors,
  lib,
  pkgs,
  ...
}:
let
  c = name: lib.removePrefix "#" colors.${name};
  src = pkgs.fishPlugins.tide.src;
  tide = {
    left_prompt_items = [
      "pwd"
      "context"
      "git"
      "node"
      "python"
      "direnv"
      "nix_shell"
      "go"
      "rustc"
      "java"
      "docker"
      "kubectl"
      "terraform"
      "aws"
      "newline"
      "character"
    ];
    right_prompt_items = [
      "status"
      "cmd_duration"
      "jobs"
    ];
    left_prompt_suffix = "''";
    character_vi_icon_replace = "'❮'";
    character_vi_icon_visual = "'❮'";
    character_color = (c "accent");
    character_color_failure = (c "red");
    pwd_color_dirs = (c "yellow");
    pwd_color_anchors = (c "yellow");
    pwd_color_truncated_dirs = (c "overlay1");
    pwd_markers = [
      ".git"
      ".hg"
      ".svn"
      "package.json"
      "Cargo.toml"
      "go.mod"
      "pyproject.toml"
    ];
    pwd_icon = "\\x1d";
    pwd_icon_home = "\\x1d";
    pwd_icon_unwritable = "\\x1d";
    context_always_display = "true";
    context_color_default = (c "red");
    context_color_root = (c "green");
    context_color_ssh = (c "red");
    git_icon = "' '";
    git_color_branch = (c "mauve");
    git_color_dirty = (c "yellow");
    git_color_operation = (c "red");
    git_color_staged = (c "green");
    git_color_stash = (c "green");
    git_color_conflicted = (c "red");
    git_color_untracked = (c "blue");
    git_color_upstream = (c "blue");
    status_color = (c "green");
    status_color_failure = (c "red");
    cmd_duration_color = (c "overlay0");
    cmd_duration_threshold = "2000";
    jobs_color = (c "sky");
    jobs_icon = "'✦'";
    node_icon = "' '";
    node_color = (c "green");
    python_icon = "'󰌠 '";
    python_color = (c "yellow");
    go_icon = "' '";
    go_color = (c "sapphire");
    rustc_icon = "' '";
    rustc_color = (c "peach");
    java_icon = "' '";
    java_color = (c "red");
    docker_icon = "'󰡨 '";
    docker_color = (c "blue");
    kubectl_icon = "'󱃾 '";
    kubectl_color = (c "sky");
    terraform_icon = "'󱁢 '";
    terraform_color = (c "mauve");
    aws_icon = "'☁ '";
    aws_color = (c "yellow");
    right_prompt_prefix = "''";
    prompt_color_frame_and_connection = (c "overlay0");
    prompt_color_separator_same_color = (c "overlay0");
  };
in
{
  # tide
  xdg.configFile."fish/conf.d/tide.fish".text = ''
    string match -r '^set -g _tide_color_.*' < ${src}/functions/_tide_sub_configure.fish | source
    string replace -r '^' 'set -g ' < ${src}/functions/tide/configure/icons.fish | source
    string replace -r '^' 'set -g ' < ${src}/functions/tide/configure/configs/lean.fish | source
  ''
  + lib.concatStrings (
    lib.mapAttrsToList (k: v: "set -g tide_${k} ${lib.concatStringsSep " " (lib.toList v)}\n") tide
  );
}
