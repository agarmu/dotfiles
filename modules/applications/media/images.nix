{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ silicon ];
    };
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      xdg.mimeApps.defaultApplications = {
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
        "image/bmp" = [ "org.gnome.Loupe.desktop" ];
        "image/tiff" = [ "org.gnome.Loupe.desktop" ];
      };
      home.packages = [ pkgs.loupe ];
    };
  flake.modules.homeManager.image =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        imagemagick # Tooling to work with images
        exiftool # image exif data
        ffmpeg # Audio library/tool
        # TODO: switch back once https://github.com/NixOS/nixpkgs/pull/541646 is merged
        stable.darktable
      ];
    };
}
