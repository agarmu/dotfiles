{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ wakatime-cli ];
      programs.nixvim.plugins.wakatime.enable = true;
      programs.zed-editor.extensions = [ "wakatime" ];
    };
}
