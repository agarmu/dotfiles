_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.rofi = {
      enable = true;
    };
  };
}
