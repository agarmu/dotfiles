{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      net = if (pkgs.stdenv.isLinux) then pkgs.iputils else pkgs.inetutils;
    in
    {
      home.packages = with pkgs; [
        aria2 # CLI download utility
        socat # Better netcat
        wget2 # Web Get (v2)
        curl # client for URL
        rsync # fast remote sync
        net
        nmap # Network Discovery tool
      ];
    };
}
