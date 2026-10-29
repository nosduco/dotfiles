{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  ollama = osConfig.services.ollama;
in
{
  # obsidian
  programs.obsidian.package = pkgs.obsidian.override { commandLineArgs = "--disable-gpu"; };

  # firefox
  programs.firefox.profiles.default.settings."media.hardware-video-decoding.force-enabled" = true;

  # prismlauncher
  programs.prismlauncher.settings = {
    MinMemAlloc = 8000;
    MaxMemAlloc = 16000;
  };

  # voxtype
  programs.voxtype = {
    model.name = "large-v3-turbo";
    settings.whisper.gpu_isolation = true;
  };

  # pi
  programs.pi-coding-agent = {
    models.providers.ollama = {
      baseUrl = "http://${ollama.host}:${toString ollama.port}/v1";
      api = "openai-completions";
      apiKey = "ollama";
      models = [
        {
          id = "qwen3.8:27b";
          contextWindow = lib.toInt ollama.environmentVariables.OLLAMA_CONTEXT_LENGTH;
          reasoning = true;
          input = [
            "text"
            "image"
          ];
        }
      ];
    };
    settings = {
      defaultProvider = "ollama";
      defaultModel = "qwen3.8:27b";
    };
  };

  # apps
  home.packages = [
    pkgs.nvtopPackages.nvidia
    pkgs.oversteer
  ];
}
