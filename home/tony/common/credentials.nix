{ osConfig, ... }:
{
  # env
  programs.fish.shellInit = ''
    if test -r ${osConfig.sops.secrets.env.path}
      for line in (string match -rv '^\s*(#|$)' < ${osConfig.sops.secrets.env.path})
        set -gx (string split -m1 = -- $line)
      end
    end
  '';
}
