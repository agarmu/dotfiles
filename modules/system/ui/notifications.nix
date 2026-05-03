_: {
  flake.modules.homeManager.nixosGui = {
    services.mako = {
      enable = true;
      settings = {
        actions = true;
        anchor = "top-right";
        default-timeout = 8000;
        layer = "overlay";
        max-visible = 5;
        sort = "-time";
        width = 400;
        height = 400;
        margin = "10";
        padding = "10";
        border-radius = 8;
        border-size = 2;
        icons = true;
      };
    };
    stylix.targets.mako.enable = true;
  };
}
