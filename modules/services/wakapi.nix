_:
let
  domain = "wakapi.internal";
  host = "millet";
  port = 54345;
in
{
  flake.modules.nixos.base.networking.extraProxies."${domain}" = "${host}.internal";
  flake.modules.nixos."host-${host}" = {
    services.wakapi = {
      enable = true;
      database.createLocally = true;
      settings = {
        server = {
          inherit port;
          public_url = "https://${domain}";
        };
        db = {
          dialect = "postgres";
          host = "/run/postgresql";
          port = 5432;
          name = "wakapi";
          user = "wakapi";
        };
        security = {
          allow_signup = true;
          disable_frontpage = false;
        };
      };
    };
    services.caddy.virtualHosts."${domain}" = {
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString port};
      '';
    };
  };
}
