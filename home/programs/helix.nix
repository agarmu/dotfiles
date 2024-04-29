{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = false;
    package = inputs.helix.packages.${system}.default;
  };
}
