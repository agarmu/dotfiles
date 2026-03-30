_: {
  flake-file.inputs.statix = {
    url = "github:molybdenumsoftware/statix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-parts.follows = "flake-parts";
  };
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
