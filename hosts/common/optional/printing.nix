{ pkgs, ... }:
{
  # printing
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };
  programs.system-config-printer.enable = true;
  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP-DeskJet-2700-series";
        description = "HP DeskJet 2700 series";
        deviceUri = "hp:/net/DeskJet_2700_series?hostname=HP28C5C89717BD.local";
        model = "HP/hp-deskjet_2700_series.ppd.gz";
      }
    ];
    ensureDefaultPrinter = "HP-DeskJet-2700-series";
  };

  # discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
