let
  module = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      nix-output-monitor
      nix-diff
      nurl
      dix
    ];
  };
in
{
  flake.modules.nixos.base = {
    programs.nh.enable = true;
    imports = [ module ];
  };
  flake.modules.darwin.base = module;
  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        nixpkgs-review
        nixpkgs-hammering
        hydra-check
        deadnix
        statix
        nixfmt
      ];
      programs.nixvim.plugins.treesitter.grammarPackages =
        with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [ nix ];
      programs.nixvim.plugins.lsp.servers.nixd = {
        enable = true;
        package = null;
        settings.nixd = {
          formatting.command = [ "nixfmt" ];
        };
      };
      programs.zed-editor.extensions = [ "nix" ];
    };
}
