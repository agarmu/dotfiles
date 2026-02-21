_: {
  flake.modules.nixos.base = _: {
    virtualisation.libvirtd = {
      enable = true;
      qemu.runAsRoot = false;
    };
    users.users.mukul.extraGroups = [ "libvirtd" ];
  };
}
