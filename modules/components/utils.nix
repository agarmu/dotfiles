_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        coreutils-full
        findutils
        diffutils
        moreutils # more utilities
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
        hexyl # hex editing
        killall # kill processes by nae
        bc # calculator
        chase # resolve symlinks
        fastfetch
        fend
        grc
        trash-cli
        gdu
        pkgs.mukul.why
        pciutils # pci devices
      ];
    };
}
