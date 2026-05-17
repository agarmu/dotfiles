{ inputs, ... }:
{
  flake.modules.homeManager.gui =
    { pkgs, config, ... }:
    {
      imports = [ inputs.dots-private.modules.homeManager.rbw ];
      # better cli client for bitwarden
      programs.rbw = {
        enable = true;
        settings = {
          # the imported module sets `email`.
          # https://github.com/nix-community/home-manager/issues/9126
          pinentry = config.services.gpg-agent.pinentry.package;
          lock_timeout = 300;
        };
      };

      # gui client
      home.packages = [ pkgs.bitwarden-desktop ];
    };
}
