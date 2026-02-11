{ lib, ... }:
{
  flake.modules.home.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        asm-lsp
      ];
    };
}
