_: {
  flake.modules.homeManager.base = _: {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          email = "vcs@agarmu.com";
          name = "Mukul Agarwal";
        };
        signing = {
          behavior = "own";
          backend = "gpg";
        };
      };
    };
  };
}
