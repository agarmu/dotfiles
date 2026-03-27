_: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        virtiofsd
      ];

      virtualisation.libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
      users.users.mukul.extraGroups = [ "libvirtd" ];
    };
}
