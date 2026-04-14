{ lib, ... }:
{
  flake.modules.nixos.base = _: {
    options.networking.extraProxies = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "dnscrypt-proxy cloaking rules rendered as CNAME-like aliases.";
    };

    /*
      the `static` config option expects
      something like
      [static.'domain']
      target = 'blah blah blah'
    */
    # config.services.dnscrypt-proxy.settings.static =
    #    config.networking.extraProxies |> builtins.mapAttrs (_: target: { inherit target; });
  };
}
