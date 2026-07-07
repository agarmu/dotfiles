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
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        nixpkgs-review
        nixpkgs-hammering
        deadnix
        statix
        nixfmt
      ];
      programs.nixvim.plugins.lsp.servers.nixd = {
        enable = true;
        package = null;
      };
      programs.zed-editor.extensions = [ "nix" ];
    };
}
