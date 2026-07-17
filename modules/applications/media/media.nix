{
  flake.modules.homeManager.base = {
    programs.yt-dlp.enable = true;
  };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        freetube
      ];
      programs.mpv = {
        package = pkgs.mpv.override {
          scripts =
            (with pkgs.mpvScripts; [ mpris ])
            |> builtins.filter (pkgs.lib.meta.availableOn pkgs.stdenv.hostPlatform);
        };
        enable = true;
        config = {
          input-ipc-server = "/tmp/mpv-socket";
        };
      };
    };
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        playerctl
      ];
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
}
