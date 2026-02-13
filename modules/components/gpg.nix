{ lib, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.gpg = {
        enable = true;
      };
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        # todo --- better way ?
        enableBashIntegration = true;
        enableZshIntegration = true;
        pinentry.package = lib.mkDefault pkgs.pinentry-curses;
      };
    };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      services.gnome-keyring = {
        enable = true;
        components = [ "secrets" ];
      };
      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
    };
  flake.modules.darwin.gui = {
    homebrew.casks = [ "gpg-suite-pinentry" ];
  };
}
