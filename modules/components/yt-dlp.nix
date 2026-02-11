_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.yt-dlp = {
        enable = true;
      };
    };
}
