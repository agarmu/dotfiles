{ lib, ... }: {
  flake.modules.homeManager.darwin =
    { pkgs, ... }:
    {
      services.hister = {
        enable = true;
        url = "http://127.0.0.1:4433";
        settings.extractors.ytdlp = {
          enable = true;
          options = {
            binary = lib.getExe pkgs.yt-dlp;
            timeout = 30;
            max_concurrent_jobs = 2;
            fetch_subtitles = true;
            sub_language = "en";
            cookies_from_browser = "firefox";
          };
        };
      };
    };
}
