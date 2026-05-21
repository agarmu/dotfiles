{
  flake.modules.homeManager.nixosGui =
    { ... }:
    {
      programs.waybar.settings.mainBar = {
      };
    };
}
