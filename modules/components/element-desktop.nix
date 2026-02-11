{lib, ...}:
{
  flake.modules.homeManager.gui = {
    programs.element-desktop.enable = true;
  };
}
