_: {
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      services.mako.enable = true;
      services.cliphist.enable = true;
      programs.fuzzel.enable = true;
      programs.hyprlock.enable = true;
    };
}
