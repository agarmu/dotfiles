{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.nixvim.plugins.lsp.servers.nixd.enable = true;
      programs.zed-editor.extensions = [ "nix" ];
      home.packages = with pkgs; [
        nixd
        deadnix # dead code detection
        statix # static analysis
        nix-tree
      ];
    };
}
