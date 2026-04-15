_:
let
  domain = "wakapi.internal";
  host = "millet";
  port = 54345;
in
{
  flake.modules.nixos.base.networking.extraProxies."${domain}" = "${host}.internal";
  flake.modules.nixos."host-${host}" =
    { config, ... }:
    {
      sops.secrets."wakapi-password-salt" = { };
      sops.templates."wakapi-env-file".content = ''
        WAKAPI_PASSWORD_SALT="${config.sops.placeholder."wakapi-password-salt"}"
      '';
      services.wakapi = {
        enable = true;
        database.createLocally = true;
        environmentFiles = [
          config.sops.templates."wakapi-env-file".path
        ];
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
            allow_signup = false;
            disable_frontpage = true;
            invite_codes = false;
            # ok bc on https
            insecure_cookies = false;
          };
          app = {
            leaderboard_enabled = false;
            max_inactive_months = 48;
            custom_languages = {
              nix = "Nix";
              rs = "Rust";
              scala = "Scala";
            };
          };
        };
      };
      services.caddy.virtualHosts."${domain}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${toString port}
        '';
      };
    };
}
