_: {
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.tealdeer = {
        enable = true;
        settings.updates.auto_update = true;
      };
      home.packages = with pkgs; [
        coreutils-full
        hyperfine
        tokei # code statistics
        fswatch
        peco # interactive filtering/reading etc
        duf # better df
        dust # better du
        procs # better ps
        grex # regex generator
        xh # HTTP client
        file # Gets file type
        which # Gets executable path
        gnused # GNU version of sed
        gnutar # GNU version of tar
        gawk # GNU version of AWK
        qrencode # Works with qr codes
        parallel # GNU Parallel
        pv # progressbar
      ];
    };
}
