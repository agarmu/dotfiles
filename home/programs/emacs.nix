{
  config,
  pkgs,
  inputs,
  ...
}: let
in {
  programs.emacs = {
    enable = true;
  };
}
