{ ... }:
{
  flake.modules.homeManager.base = {
    services.gpg-agent.enable = true;
    programs.gpg.enable = true;
  };
  flake.modules.darwin.gui = {
    homebrew.brews = [ "gpg-pinentry" ];
  };
}
