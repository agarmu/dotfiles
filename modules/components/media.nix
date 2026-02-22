_: {
  flake.modules.homeManager.base = _: {
    programs.yt-dlp.enable = true;
  };
  flake.modules.homeManager.gui = {
    programs.mpv.enable = true;
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
