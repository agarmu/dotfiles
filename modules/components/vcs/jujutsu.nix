{
  flake.modules.homeManager.base = {
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
    programs.jjui.enable = true;
  };
}
