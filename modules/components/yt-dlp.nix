_: {
  flake.modules.homeManager.base =
    { ... }:
    {
      programs.yt-dlp = {
        enable = true;
      };
    };
}
