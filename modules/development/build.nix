{ lib, ... }:
{
  flake.modules.home.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cmake # Very bad but must use
        gnumake # Often used badly
        just # More sane makefile
        meson # build tool
      ];
    };
}
