{
  flake.modules.nixos.base.web-services.wakapi = {
    host = "millet";
    port = 54345;
  };

  flake.modules.nixos.host-millet =
    { config, ... }:
    {
      sops.secrets."wakapi-password-salt" = { };
      sops.templates."wakapi-env-file".content = ''
        WAKAPI_PASSWORD_SALT="${config.sops.placeholder."wakapi-password-salt"}"
      '';
      services.wakapi = {
        enable = true;
        database.createLocally = true;
        environmentFiles = [ config.sops.templates."wakapi-env-file".path ];
        settings = {
          server = {
            port = 54345;
            public_url = "https://wakapi.internal";
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
    };
}
