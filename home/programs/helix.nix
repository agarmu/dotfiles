{
  config,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };
}
