_: {
  # TODO: Configure restic backups
  # - Add Backblaze B2 as backup target
  # - Set up secrets management for B2 credentials (sops-nix / agenix)
  # - Configure backup paths and exclude patterns
  # - Set up backup timer schedule
  #
  # Example:
  # services.restic.backups.b2 = {
  #   repository = "b2:bucket-name:path";
  #   passwordFile = "/path/to/restic-password";
  #   environmentFile = "/path/to/b2-credentials";
  #   paths = [ "/home/mukul" ];
  #   exclude = [ ".cache" "node_modules" ".direnv" "result" ];
  #   timerConfig = { OnCalendar = "daily"; Persistent = true; };
  # };
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ restic ];
    };
}
