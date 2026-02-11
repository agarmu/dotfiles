{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-curses;
      };
    };
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ pinentry-curses ];
    };
  flake.modules.darwin.gui = {
    homebrew.casks = [ "gpg-suite-pinentry" ];
  };
}
