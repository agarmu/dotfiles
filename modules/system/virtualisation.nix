{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        virtiofsd
        devcontainer
      ];

      virtualisation.libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
      virtualisation.docker.enable = true;
      users.users.mukul.extraGroups = [
        "libvirtd"
        "docker"
      ];
    };
}
