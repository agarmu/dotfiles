_: {
  flake.modules.homeManager.base = _: {
    programs.yt-dlp = {
      enable = true;
    };
  };
}
