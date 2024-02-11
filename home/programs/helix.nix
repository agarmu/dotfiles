{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = false;
    package = inputs.helix.packages."aarch64-darwin".default;
  };
}
