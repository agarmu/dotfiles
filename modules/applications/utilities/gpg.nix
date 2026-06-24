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
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.kdePackages.kwalletmanager ];
      services.gpg-agent.pinentry.package = pkgs.pinentry-qt;
    };
  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [ pkgs.pinentry_mac ];
    services.gpg-agent.pinentry.package = pkgs.pinentry_mac;
  };
}
