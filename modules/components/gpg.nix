{ ... }:
{
  flake.modules.nixos.base = {
    programs.gnupg = {
      enable = true;
      agent = {
        enable = true;
        enableSSHSupport = true;
        pinentry.package = pinentry-curses;
      };
    };
  };
  flake.modules.darwin.gui = {
    homebrew.casks = [ "gpg-suite-pinentry" ];
  };
}
