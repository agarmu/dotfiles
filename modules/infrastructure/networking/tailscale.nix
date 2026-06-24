{ lib, ... }:
let
  tailnetHosts = [
    "millet"
    "wheat"
    "data"
  ];
in
{
  flake.modules.nixos.base = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = lib.mkDefault "both";
      extraUpFlags = "--accept-routes";

      /*
        	and don't track me
                https://nixos.wiki/wiki/Tailscale
      */
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };

    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];
    networking.extraProxies =
      tailnetHosts
      |> map (name: {
        name = "${name}.internal";
        value = "${name}.tail7434b.ts.net";
      })
      |> lib.listToAttrs;
  };
  flake.modules.darwin.base = {
    services.tailscale.enable = true;
  };

  flake.modules.homeManager.linuxGui = {
    services.tailscale-systray.enable = true;
  };
}
