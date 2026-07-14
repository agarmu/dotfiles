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
        # TODO: go back once https://github.com/NixOS/nixpkgs/pull/541654 is merged
        package = pkgs.stable.mpv.override {
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
