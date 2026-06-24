{
  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    let
      net = if pkgs.stdenv.isLinux then pkgs.iputils else pkgs.inetutils;
    in
    {
      home.packages =
        with pkgs;
        [
          aria2 # CLI download utility
          socat # Better netcat
          wget # Web Get (v1)
          wget2 # Web Get (rewritten)
          curl # client for URL
          rsync # fast remote sync
          net
          nmap # Network Discovery tool
          lsof # list open files/ports
          rclone # cloud storage CLI (S3, GDrive, B2, etc.)
          dnsutils # dig, nslookup, etc.
          doggo # pretty dig
          xh # HTTP client
          gping # graphical ping
          whois
        ]
        ++ (lib.optionals pkgs.stdenv.isLinux [ nethogs ]);
      home.shellAliases.ping = "${pkgs.gping}/bin/gping";
    };
  flake.modules.nixos.base = {
    programs.mtr.enable = true;
    services.iperf3 = {
      enable = true;
      openFirewall = true;
    };
  };
}
