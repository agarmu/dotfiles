let
  identity = {
    email = "vcs@agarmu.com";
    name = "Mukul Agarwal";
  };
in
{
  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        difftastic
      ];
      programs.git = {
        enable = true;
        package = pkgs.gitFull;
        settings = {
          user = identity;
          init.defaultBranch = "main";
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
          key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
          signByDefault = true;
          format = "ssh";
        };
      };

      programs.jujutsu = {
        enable = true;
        settings = {
          user = identity;
          signing = {
            behavior = "own";
            backend = "ssh";
          };
        };
      };
      programs.jjui.enable = true;

      programs.lazygit.enable = true;
    };
}
