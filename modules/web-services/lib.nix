{
  flake.modules.nixos.base =
    { lib, config, ... }:
    let
      cfg = config.web-services;
      serviceOpts =
        { name, ... }:
        {
          options = {
            domain = lib.mkOption {
              type = lib.types.str;
              default = "${name}.internal";
              description = "Internal hostname for this service.";
            };
            host = lib.mkOption {
              type = lib.types.str;
              description = "NixOS host that runs this service (e.g. \"millet\").";
            };
            port = lib.mkOption {
              type = lib.types.port;
              description = "Local TCP port the service listens on.";
            };
          };
        };
    in
    {
      options.web-services = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule serviceOpts);
        default = { };
        description = "Declarative Caddy-proxied internal web services.";
      };

      config = {
        # Register every service's domain as an extraProxy on all hosts.
        networking.extraProxies = lib.mapAttrs (_: svc: "${svc.host}.internal") cfg;

        # On the host that owns a service, add the Caddy reverse_proxy vhost.
        services.caddy.virtualHosts = lib.pipe cfg [
          (lib.filterAttrs (_: svc: svc.host == config.networking.hostName))
          (lib.mapAttrs' (
            _: svc:
            lib.nameValuePair svc.domain {
              extraConfig = ''
                reverse_proxy 127.0.0.1:${toString svc.port}
              '';
            }
          ))
        ];
      };
    };
}
