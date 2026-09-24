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

    # betterfox
    betterfox.url = "github:yokoffing/Betterfox";
    betterfox.flake = false;

    # spicetify
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # claude desktop
    claude-desktop.url = "github:patrickjaja/claude-desktop-extra";
    claude-desktop.inputs.nixpkgs.follows = "nixpkgs";

    # helium
    helium.url = "github:amaanq/helium-flake";
    helium.inputs.nixpkgs.follows = "nixpkgs";

    # aws vpn client
    awsvpnclient-nix.url = "github:AddG0/awsvpnclient-nix/b187895a5f5998adc9bbc14ca8cdaa24e39ddd5a";
    awsvpnclient-nix.inputs.nixpkgs.follows = "nixpkgs";
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
