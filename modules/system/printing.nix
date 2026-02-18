_: {
  flake.modules.nixos.mobile = {
    # services.avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    #   openFirewall = true;
    # };
  };
  flake.modules.nixos.office =
    { pkgs, ... }:
    {
      services.samba = {
        enable = true;
      };
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          hplip
          postscript-lexmark
        ];
      };
      # hardware.printers.ensurePrinters =
      #   (builtins.readFile ./purdue-printers.json)
      #   |> builtins.fromJSON
      #   |> builtins.filter (x: (x.building == "LWSN") || (x.building == "DSAI"))
      #   |> map (x: parse x.building x.id)
      #   |> builtins.filter filterPurduePrinter
      #   |> map makePurduePrinter;
    };
}
