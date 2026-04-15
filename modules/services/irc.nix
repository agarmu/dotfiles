_:
let
  domain = "irc.internal";
  host = "millet";
  port = 9000;
in
{
  flake.modules.nixos.base.networking.extraProxies."${domain}" = "${host}.internal";

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
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };

  };
}
