_: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.nh.enable = true;
      environment.systemPackages = with pkgs; [
        nix-output-monitor
        nix-diff
        nurl
        dix
      ];
    };
}
