let
  # Shared configuration for both Darwin and NixOS
  sharedGuiConfig = {
    # see https://github.com/NixOS/nixpkgs/issues/526914
    nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];
    nixpkgs.overlays = [
      (final: prev: {
        # Use prebuilt electron binary to avoid building from source
        bitwarden-desktop = prev.bitwarden-desktop.override {
          electron_39 = final.electron_39-bin;
        };
      })
    ];
  };
in
{
  flake.modules.nixos.gui = sharedGuiConfig;
  flake.modules.darwin.gui = sharedGuiConfig;

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
