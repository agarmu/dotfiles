_:
let
  domain = "change.internal";
  host = "millet";
  port = 5000;
in
{
  flake.modules.nixos.base.networking.extraProxies."${domain}" = "${host}.internal";
  flake.modules.nixos."host-${host}" = {
    services.changedetection-io = {
      enable = true;
      listenAddress = "127.0.0.1";
      inherit port;
    };

    services.caddy.virtualHosts."${domain}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };
}
