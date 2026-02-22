_: {
  flake.modules.homeManager.nixosGui = _: {
    services.mako.enable = true;
    services.cliphist.enable = true;
    programs.vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
      };
    };

    programs.hyprlock.enable = true;
  };
}
