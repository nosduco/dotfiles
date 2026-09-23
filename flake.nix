{
  description = "nosduco/dotfiles";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # catppuccin
    catppuccin.url = "github:catppuccin/nix";

    # yazi flavors
    yazi-flavors.url = "github:yazi-rs/flavors";
    yazi-flavors.flake = false;

    # tmux power
    tmux-power.url = "github:wfxr/tmux-power";
    tmux-power.flake = false;
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    {
      nixosConfigurations = {
        nighthawk = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/nighthawk ];
        };
        voyager = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/voyager ];
        };
      };
    };
}
