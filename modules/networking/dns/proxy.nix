{ lib, ... }:
{
  flake.modules.nixos.base = _: {
    options.networking.extraProxies = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "dnscrypt-proxy cloaking rules rendered as CNAME-like aliases.";
    };
  };
}
