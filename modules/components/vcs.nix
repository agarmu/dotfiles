{ lib, ... }:
let
  user = {
    email = "vcs@agarmu.com";
    name = "Mukul Agarwal";
  };
in
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          inherit user;
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
      programs.jujutsu = {
        enable = true;
        settings = {
          inherit user;
          signing = {
            behavior = "own";
            backend = "gpg";
          };
        };
      };

      programs.lazygit.enable = true;
      catppuccin.lazygit.enable = true;
      programs.jjui.enable = true;

      # configure delta to work with these!
      programs.delta = {
        enable = lib.mkDefault true;
        enableGitIntegration = true;
        enableJujutsuIntegration = true;
      };
    };
}
