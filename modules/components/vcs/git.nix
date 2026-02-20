_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        package = pkgs.gitFull;
        settings = {
          user = {
            email = "vcs@agarmu.com";
            name = "Mukul Agarwal";
          };
          alias = {
            c = "commit";
            cl = "clone";
            co = "checkout";
            d = "diff";
            ds = "diff --staged";
            s = "status";
            l = "log";
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
