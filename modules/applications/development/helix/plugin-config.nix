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
  };
}
