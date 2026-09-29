let
  btrfs = [
    "compress=zstd"
    "noatime"
  ];
  luks = name: content: {
    type = "luks";
    inherit name content;
    passwordFile = "/tmp/secret.key";
    settings = {
      allowDiscards = true;
      crypttabExtraOpts = [ "tpm2-device=auto" ];
    };
  };
in
{
  # disk
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-KINGSTON_SKC3000S1024G_50026B768708041D";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "2G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          end = "-66G";
          content = luks "cryptroot" {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = btrfs;
              };
              "/home" = {
                mountpoint = "/home";
                mountOptions = btrfs;
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = btrfs;
              };
              "/log" = {
                mountpoint = "/var/log";
                mountOptions = btrfs;
              };
            };
          };
        };
        swap = {
          size = "100%";
          content = luks "cryptswap" {
            type = "swap";
            resumeDevice = true;
          };
        };
      };
    };
  };
}
