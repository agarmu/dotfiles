{
  flake.modules.homeManager.base = {
    programs.yt-dlp.enable = true;
  };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.playerctl ];
      programs.mpv = {
        package = pkgs.mpv.override {
          scripts = [ pkgs.mpvScripts.mpris ];
        };
        enable = true;
        config = {
          input-ipc-server = "/tmp/mpv-socket";
        };
      };
      xdg.mimeApps.defaultApplications = {
        "video/mp4" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-msvideo" = [ "mpv.desktop" ];
        "audio/mpeg" = [ "mpv.desktop" ];
        "audio/flac" = [ "mpv.desktop" ];
        "audio/ogg" = [ "mpv.desktop" ];
        "audio/wav" = [ "mpv.desktop" ];
      };
    };
  flake.modules.homeManager.nixosGui = {
    programs.freetube.enable = true;
  };
}
