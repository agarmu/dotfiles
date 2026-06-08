{
  flake.modules.nixos.gui =
    { ... }:
    {
      # see https://github.com/NixOS/nixpkgs/issues/526914
      nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];
    };
  flake.modules.homeManager.gui =
    { pkgs, config, ... }:
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
      home.packages = [ pkgs.bitwarden-desktop ];
    };
}
