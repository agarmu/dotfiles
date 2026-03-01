_: {
  flake.modules.nixos.asahi =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        apfs-fuse
        apfsprogs
      ];
    };
}
