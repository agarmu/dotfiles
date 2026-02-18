{ ... }:
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd # lsp
        deadnix # dead code detection
        statix # static analysis
        nix-tree
      ];
    };
}
