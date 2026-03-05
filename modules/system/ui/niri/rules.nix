_: {
  flake.modules.homeManager.nixosGui = _: {
    programs.niri.settings.window-rules = [ ];
  };
}
