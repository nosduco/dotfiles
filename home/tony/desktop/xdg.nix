{ config, lib, ... }:
let
  home = config.home.homeDirectory;
in
{
  # user dirs
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    desktop = "${home}/desktop";
    documents = "${home}/documents";
    download = "${home}/downloads";
    music = "${home}/music";
    pictures = "${home}/pictures";
    projects = "${home}/projects";
    publicShare = "${home}/public";
    templates = "${home}/templates";
    videos = "${home}/videos";
  };

  # default apps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.mergeAttrsList (
      lib.mapAttrsToList (app: types: lib.genAttrs types (_: "${app}.desktop")) {
        firefox = [
          "text/html"
          "application/xhtml+xml"
          "application/pdf"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/mailto"
        ];
        nvim = [
          "text/plain"
          "text/markdown"
          "text/x-python"
          "application/json"
          "application/toml"
          "application/x-yaml"
          "application/x-shellscript"
        ];
        "org.gnome.Loupe" = [
          "image/png"
          "image/jpeg"
          "image/gif"
          "image/webp"
          "image/avif"
          "image/svg+xml"
        ];
        mpv = [
          "video/mp4"
          "video/webm"
          "video/x-matroska"
          "video/quicktime"
          "audio/mpeg"
          "audio/flac"
          "audio/ogg"
          "audio/wav"
          "audio/mp4"
        ];
        "org.gnome.Nautilus" = [ "inode/directory" ];
        yazi = [
          "application/zip"
          "application/x-7z-compressed"
          "application/vnd.rar"
          "application/x-tar"
          "application/x-compressed-tar"
          "application/x-bzip2-compressed-tar"
          "application/x-xz-compressed-tar"
          "application/x-zstd-compressed-tar"
          "application/gzip"
        ];
        vesktop = [ "x-scheme-handler/discord" ];
        slack = [ "x-scheme-handler/slack" ];
        "com.anthropic.Claude" = [ "x-scheme-handler/claude" ];
      }
    );
  };
}
