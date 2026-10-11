{
  flake.modules.homeManager.steelix = {
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
