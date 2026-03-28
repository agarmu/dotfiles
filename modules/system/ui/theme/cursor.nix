_: {
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      stylix.cursor = {
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-dark";
        size = 24;
      };
    };
}
