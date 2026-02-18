{lib, ...}:
{
    flake.modules.nixos.gui = {pkgs, ...}:
    {
      stylix.cursor = {
        package = pkgs.mint-cursor-themes;
        name = "Bibata-Modern-Ice";
      };
    };
}
