_: {
  flake.modules.homeManager.nixosGui = {
    services.avizo.enable = true;
    services.avizo.settings.default = {
      time = 0.5;
      fade-in = 0.1;
      fade-out = 0.2;
    };
  };
}
