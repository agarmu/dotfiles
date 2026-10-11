{
  flake.modules.homeManager.dev = {
    programs.helix.enable = true;
    stylix.targets.helix.enable = false;
  };
}
