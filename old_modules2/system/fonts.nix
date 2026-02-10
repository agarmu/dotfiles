{ pkgs, ... }:
{
  flake.modules.nixos.base = {
    /*
      why do we include fonts in base?
      well... we want to be able to use
      them for automated tasks/compilation,
      e.g. LaTeX
    */
    fonts.packages = with pkgs; [
      inconsolata
      cascadia-code
      cm_unicode
      lmodern
    ];
  };
}
