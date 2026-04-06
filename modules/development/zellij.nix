_: {
  flake.modules.homeManager.dev = {
    stylix.targets.zellij = {
      enable = true;
      colors.enable = true;
    };
    programs.zellij.enable = true;
  };
}
