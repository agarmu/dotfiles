{
  config,
  pkgs,
  ...
}: {
  nix = {
    gc = {
      automatic = true;
      interval = {
        Hour = 24;
        Minute = 0;
      };
    };
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon = {
    enable = true;
  };
}
