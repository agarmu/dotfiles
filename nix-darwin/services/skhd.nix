{
  config,
  pkgs,
  ...
}: {
  services.skhd = {
    enable = false;
  };
}
