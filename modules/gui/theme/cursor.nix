{
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      stylix.cursor = {
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-light";
        size = 24;
      };
    };
}
