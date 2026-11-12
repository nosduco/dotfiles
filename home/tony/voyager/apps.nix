{ pkgs, ... }:
{
  # nvtop
  home.packages = [ pkgs.nvtopPackages.amd ];

  # voxtype
  services.voxtype.settings.whisper.model = "${pkgs.fetchurl {
    url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin";
    hash = "sha256-oDd5yG3zMjB19eeWyyzlAp8A7Ihp7uP9+4l6/jbG0AI=";
  }}";
}
