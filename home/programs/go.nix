{
  config,
  pkgs,
  ...
}: {
  programs.go = {
    enable = true;
    packages = {
    };
  };
}
