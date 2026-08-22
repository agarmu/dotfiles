{
  # GUI file manager (Nautilus)
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.nautilus ];
      xdg.mimeApps.defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };
    };
  flake.modules.nixos.gui =
    { pkgs, ... }:
    {
      programs.nautilus-open-any-terminal = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        nautilus
        file-roller # archive handling
      ];
      services.gvfs.enable = true;
      services.gnome.sushi.enable = true;
    };

  # Archive / compression / disk utils
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
      };
      home.packages = with pkgs; [
        # Archive / compression
        ouch # painless (de)compression for any format
        gnutar # GNU tar
        gzip # GNU zip
        bzip2 # bzip2 compression
        xz # xz/lzma compression
        zstd # zstandard compression
        zip # create zip archives
        unzip # extract zip archives
        p7zip # 7-zip (7z, 7za)

        # Disk & filesystem utilities
        duf # better df
        dust # better du
        ncdu # interactive disk usage explorer
      ];
    };
  flake.modules.homeManager.linux = { pkgs, ... }: {
    home.packages = [ pkgs.util-linux ];
  };
}
