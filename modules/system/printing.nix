{ lib, ... }:
let
  parse =
    building: ident:
    let stripped = lib.removePrefix (lib.toLower building) ident;
      m = builtins.match "^([A-Za-z]*[0-9]+[A-Za-z]?)?(mfp)?(bw|co)?([0-9]+)?$" stripped;
      in
      if m == null then throw "Invalid: ${stripped}"
      else let
      room = builtins.elemAt m 0;
      mfpTok = builtins.elemAt m 1;
      mode = builtins.elemAt m 2;
      in
      {
        inherit building ident room;
        isColor = (mode == "co") || (mode == "col");
        mfp = mfpTok == "mfp";
      };

  filterPurduePrinter =
    { building, ... }: true;
    # (mode == "bw" || mode == "co" || mode == "col") && (building == "LWSN" || building == "DSAI");

  makePurduePrinter =
    {
      building,
      ident,
      room,
      mfp,
      isColor
    }:
      let
        mode = if isColor then "CO" else "BW";
        mfpQualifier = if mfp then "+MFP" else "";
        desc = "${lib.toUpper building}-${lib.toUpper room}-${mode}${mfpQualifier}";
      in
      {
        name = desc;
        location = "Purdue University";
        deviceUri = "lpd://print.science.purdue.edu/${ident}";
        model = "drv:///sample.drv/generic.ppd";
        ppdOptions = {
          "ColorMode" = if isColor then "color" else "monochrome";
        };
      };
in
{
  flake.modules.nixos.mobile = {
    # services.avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    #   openFirewall = true;
    # };
  };
  flake.modules.nixos.office = {pkgs, ...}: {
    services.samba = {
      enable = true;
    };
    services.printing = {
      enable = true;
    };
    hardware.printers.ensurePrinters =
      (builtins.readFile ./purdue-printers.json)
      |> builtins.fromJSON
      |> builtins.filter (x: (x.building == "LWSN") || (x.building == "DSAI"))
      |> map (x: parse x.building x.id)
      |> builtins.filter filterPurduePrinter
      |> map makePurduePrinter;
  };
}
