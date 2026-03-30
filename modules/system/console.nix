{ lib, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      console = {
        packages = [ pkgs.terminus_font ];
        font = lib.mkDefault "ter-v24n";
        earlySetup = true;
      };
    };

  flake.modules.nixos.host-wheat.console.font = "ter-v32n";
}
