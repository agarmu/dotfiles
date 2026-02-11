
{ pkgs, ... }:
{
  flake.modules.homeManager.image =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        imagemagick # Tooling to work with images
        exiftool # image exif data
        ffmpeg # Audio library/tool
        inkscape
        darktable
      ];
    };
}
