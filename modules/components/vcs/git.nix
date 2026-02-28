_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        difftastic
      ];
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
            s = "status";
            sw = "switch";
            br = "switch";
            l = "log";

            d = "diff";
            ds = "diff --staged";
            dt = "difft";
            dst = "difft --staged";
            difft = "-c diff.external=difft diff";
            ld = " log --ext-diff";
            ldt = "-c diff.external=difft log --ext-diff";
            dshow = "show --ext-diff";
            dtshow = "-c diff.external=difft show --ext-diff";
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
      programs.lazygit.enable = true;
    };
}
