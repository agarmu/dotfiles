{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.nh.enable = true;
      environment.systemPackages = with pkgs; [
        nix-output-monitor
        nix-diff
        nurl
        dix
      ];
    };
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ nixd ];
      programs.nixvim.plugins.lsp.servers.nixd = {
        enable = true;
        package = null;
      };
      programs.zed-editor.extensions = [ "nix" ];
    };
}
