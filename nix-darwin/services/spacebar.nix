{
  config,
  pkgs,
  ...
}: {
  services.spacebar = {
    enable = false;
    package = pkgs.spacebar;
  };
}
