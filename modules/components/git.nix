_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          alias = {
            c = "commit";
            cl = "clone";
            co = "checkout";
            d = "diff";
            ds = "diff --staged";
            s = "status";
            l = "log";
          };
          user = {
            email = "vcs@agarmu.com";
            name = "Mukul Agarwal";
          };
        };
        lfs = {
          enable = true;
          skipSmudge = false;
        };
        signing = {
          key = null;
          signByDefault = true;
          format = "openpgp";
        };
      };
    };
}
