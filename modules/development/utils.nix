_: {
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        coreutils-full
        file # Gets file type
        which # Gets executable path
        gnused # GNU version of sed
        gnutar # GNU version of tar
        gawk # GNU version of AWK
        parallel # GNU Parallel
        pv # progressbar
        qrencode # Works with qr codes
        peco # interactive filtering
        hyperfine # benchmarking
        tokei # code statistics
        fswatch # file system watcher
        grex # regex generator
      ];
    };
}
