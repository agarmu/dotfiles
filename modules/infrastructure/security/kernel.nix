{ inputs, lib, ... }:
let
  inherit (lib) mkDefault mkForce;
in
{
  flake.modules.nixos.securityFilesys = {
    # from old nixpkgs hardened profile
    boot.blacklistedKernelModules = [
      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "hfs"
      "hfsplus"
      "hpfs"
      "jfs"
      "jffs"
      "minix"
      "nilfs2"
      "ntfs"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "udf"
      "ufs"
      "vivid"
    ];
  };

  flake.modules.nixos.securityMemory = {
    boot.kernelParams = [
      "page_poison=1"
      "page_alloc.shuffle=1"
    ];
    security.forcePageTableIsolation = mkForce true;
  };

  flake.modules.nixos.securityNetwork = {
    boot.blacklistedKernelModules = [
      # Obscure network protocols
      "af_802154" # IEEE 802.15.4
      "appletalk"
      "atm"
      "ax25" # Amateur X.25
      "can" # Controller Area Network
      "dccp" # Datagram Congestion Control Protocol
      "decnet"
      "econet"
      "ipx" # Internetwork Packet Exchange
      "netrom" # NetRom
      "n-hdlc" # High-level Data Link Control
      "p8022" # IEE 802.3
      "p8023" # Novell raw IEE 802.3
      "psnap" # SubnetworkAccess Protocol
      "rds" # Reliable Datagram Sockets
      "rose"
      "sctp" # Stream Control Transmission Protocol
      "tipc" # Transparent Inter-Process Communication
      "x25" # X.25
    ];
    # Enable strict reverse path filtering (that is, do not attempt to route
    # packets that "obviously" do not belong to the iface's network; dropped
    # packets are logged as martians).
    boot.kernel.sysctl."net.ipv4.conf.all.log_martians" = mkDefault true;
    boot.kernel.sysctl."net.ipv4.conf.all.rp_filter" = mkDefault "1";
    boot.kernel.sysctl."net.ipv4.conf.default.log_martians" = mkDefault true;
    boot.kernel.sysctl."net.ipv4.conf.default.rp_filter" = mkDefault "1";

    # Ignore broadcast ICMP (mitigate SMURF)
    boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = mkDefault true;

    # Ignore incoming ICMP redirects (note: default is needed to ensure that the
    # setting is applied to interfaces added after the sysctls are set)
    boot.kernel.sysctl."net.ipv4.conf.all.accept_redirects" = mkDefault false;
    boot.kernel.sysctl."net.ipv4.conf.all.secure_redirects" = mkDefault false;
    boot.kernel.sysctl."net.ipv4.conf.default.accept_redirects" = mkDefault false;
    boot.kernel.sysctl."net.ipv4.conf.default.secure_redirects" = mkDefault false;
    boot.kernel.sysctl."net.ipv6.conf.all.accept_redirects" = mkDefault false;
    boot.kernel.sysctl."net.ipv6.conf.default.accept_redirects" = mkDefault false;

    # Ignore outgoing ICMP redirects (this is ipv4 only)
    boot.kernel.sysctl."net.ipv4.conf.all.send_redirects" = mkDefault false;
    boot.kernel.sysctl."net.ipv4.conf.default.send_redirects" = mkDefault false;
  };

  flake.modules.nixos.base = {
    imports = with inputs.self.modules.nixos; [
      securityFilesys
      securityMemory
      securityNetwork
    ];
  };
}
