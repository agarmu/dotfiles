{
  config,
  pkgs,
  ...
}: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    direnv-nix.enable = true;
    /*
    faster implementation of use nix
    */
  };
}
