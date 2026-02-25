_: {
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      services.mako.enable = true;
      services.cliphist.enable = true;
      programs.sherlock = {
        enable = true;
        aliases = {
          "appendix a" = {
            exec = "xdg-open 'https://nix-community.github.io/home-manager/options.xhtml'";
            keywords = "appendix a";
            name = "Home-Manager Appendix A";
          };
        };
      };
      programs.hyprlock.enable = true;
    };
}
