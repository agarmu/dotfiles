{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ silicon ];
    };
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.loupe ];
      xdg.mimeApps.defaultApplications = {
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
        "image/bmp" = [ "org.gnome.Loupe.desktop" ];
        "image/tiff" = [ "org.gnome.Loupe.desktop" ];
      };
    };
  flake.modules.homeManager.image =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        imagemagick # Tooling to work with images
        exiftool # image exif data
        ffmpeg # Audio library/tool
        darktable
      ];
    };
}
