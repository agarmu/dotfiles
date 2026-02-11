{ pkgs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aria2 # CLI download utility
        socat # Better netcat
        wget2 # Web Get (v2)
        curl # client for URL
        rsync # fast remote sync
        inetutils
        nmap # Network Discovery tool
      ];
    };
}
