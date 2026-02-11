{ lib, ... }:
{
  flake.modules.home.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        coreutils-full
        hyperfine
        scc
        fswatch
        peco # interactive filtering/reading etc
        tldr # too-long; didn't read versions of `man' pages
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
