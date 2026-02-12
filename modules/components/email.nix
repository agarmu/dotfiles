{lib, ...}:
{
  flake.modules.homeManager.gui = {pkgs, ...}:
  {
    catppuccin.thunderbird = {
      enable = true;
      profile = "default";
    };
    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        name = "default";
      };
    };
  };
}
