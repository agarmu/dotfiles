_:
let
  domain = "karakeep.internal";
  host = "millet";
  port = 43000;
in
{
  flake.modules.nixos.base.networking.extraProxies."${domain}" = "${host}.internal";
  flake.modules.nixos."host-${host}" =
    { config, ... }:
    {
      sops.secrets."karakeep-nextauth-secret" = { };
      sops.templates."karakeep-env".content = ''
        NEXTAUTH_SECRET="${config.sops.placeholder."karakeep-nextauth-secret"}"
      '';

      services.karakeep = {
        enable = true;
        environmentFile = config.sops.templates."karakeep-env".path;
        extraEnvironment = {
          PORT = toString port;
          DISABLE_SIGNUPS = "true";
          DISABLE_NEW_RELEASE_CHECK = "true";
          NEXTAUTH_URL = "https://${domain}";
        };
      };

      services.caddy.virtualHosts."${domain}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString port}
        '';
      };
    };
}
