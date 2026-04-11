{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.gpg = {
        enable = true;
      };
      home.packages = with pkgs; [ gpg-tui ];
      services.gpg-agent = {
        enable = true;
        # todo --- better way ?
        enableBashIntegration = true;
        enableZshIntegration = true;
        pinentry.package = lib.mkDefault pkgs.pinentry-curses;
      };
    };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.seahorse ];
      services.gnome-keyring = {
        components = [ "secrets" ];
      };
      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
    };
  flake.modules.darwin.gui = {
    homebrew.casks = [ "gpg-suite-pinentry" ];
  };
}
