{
  flake.modules.homeManager.dev = {
    programs.nhx.plugins.forest = {
      enable = true;
      config = {
        position = "left";
        ignore = [
          ".git"
          "target"
          ".cache"
          "pycache"
        ];
      };
    };

    programs.nhx.plugins.moka = {
      enable = true;
      config.bufferline.enable = true;
    };
  };
}
