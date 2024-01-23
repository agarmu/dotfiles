{
  config,
  pkgs,
  ...
}: {
  programs.go = {
    enable = false;
    packages = {
    };
  };
}
