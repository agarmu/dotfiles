{
  flake.modules.nixos.mobile = {
    location.provider = "geoclue2";
    services.geoclue2 = {
      enable = true;
    };
  };
}
