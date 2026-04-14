_:
let
  domain = "irc.agarmu.com";
  host = "millet";
  port = 9000;
in
{
  flake.modules.nixos.base.networking.dnscryptProxyCloaking."${domain}" = "${host}.hosts.agarmu.com";

  # enable only on host millet
  flake.modules.nixos."host-${host}" = {
    services.thelounge = {
      enable = true;
      inherit port;
      extraConfig = {
        reverseProxy = true;
        prefetch = true;
        fileUpload.enable = true;
      };
    };

    services.caddy.virtualHosts."${domain}" = {
      extraConfig = ''
        import tailnet_only
        tls internal
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };

  };
}
