{
  flake.modules.homeManager.linuxGui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gnome-calculator
      ];
    };
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
        pipe-rename # batch rename with editor
        hexyl # hex editing
        killall # kill processes by nae
        bc # calculator
        chase # resolve symlinks
        # TODO: switch fend back once #540900 is fixed.
        stable.fend
        grc
        trash-cli
        gdu
        pkgs.why
        pciutils # pci devices
        kent-class-download
        lazymake
        libnotify # for notify-send
        glow # md viewer for terminal
        pipes-rs
      ];
      programs.jq.enable = true;
      programs.jqp.enable = true;
    };
}
