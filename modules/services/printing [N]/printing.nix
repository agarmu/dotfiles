{
  flake.modules.nixos.printing = {
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = false; # don't do this willy-nilly...
    };
  };
}
