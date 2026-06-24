{
  flake.modules.homeManager.gui =
    { config, ... }:
    {
      programs.rbw = {
        enable = true;
        settings = {
          # the imported module sets `email`.
          email = "agarmukul23@gmail.com";
          pinentry = config.services.gpg-agent.pinentry.package;
          lock_timeout = 300;
        };
      };

      # gui client
      # leave disabled so long as it relies on broken electron
      # which means i would need to self-build
      # home.packages = [ pkgs.bitwarden-desktop ];
    };
}
