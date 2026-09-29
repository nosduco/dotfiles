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

    # sops
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # comin
    comin.url = "github:nlewo/comin";
    comin.inputs.nixpkgs.follows = "nixpkgs";

    # disko
    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

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

      # checks
      checks.x86_64-linux.voyager-disko = inputs.disko.lib.testLib.makeDiskoTest {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        name = "voyager-disko";
        disko-config = ./hosts/voyager/disko.nix;
        extraInstallerConfig.virtualisation.emptyDiskImages = nixpkgs.lib.mkForce [ 102400 ];
        enableOCR = true;
        bootCommands = ''
          machine.wait_for_text("[Pp]assphrase for")
          machine.send_chars("secretsecret\n")
        '';
        extraTestScript = ''
          machine.succeed("cryptsetup isLuks /dev/vda2")
          machine.succeed("cryptsetup isLuks /dev/vda3")
          for m in ["/", "/home", "/nix", "/var/log"]:
              machine.succeed(f"findmnt -no FSTYPE {m} | grep -qx btrfs")
          machine.succeed("findmnt -no OPTIONS / | grep -q compress=zstd")
          machine.succeed("swapon --show=NAME --noheadings | grep -q dm-")
          machine.succeed("test \"$(cat /sys/power/resume)\" != 0:0")
          machine.shutdown()
        '';
      };
    };
}
