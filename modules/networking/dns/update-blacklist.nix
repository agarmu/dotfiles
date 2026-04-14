_: {
  flake.modules.nixos.base =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      blacklistUrl = "https://download.dnscrypt.info/blacklists/domains/mybase.txt";
      blacklistPath = "/run/dnscrypt-proxy/block.txt";
    in
    lib.mkIf config.services.dnscrypt-proxy.enable {
      systemd.services.update-dnscrypt-blacklist = {
        description = "Update dnscrypt-proxy blacklist";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        path = [
          pkgs.curl
          pkgs.coreutils
        ];
        serviceConfig.Type = "oneshot";
        script = ''
          tmp="$(mktemp)"
          if curl --fail -sSL -o "$tmp" "${blacklistUrl}"; then
            chmod 444 "$tmp"
            mv "$tmp" "${blacklistPath}"
          else
            rm -f "$tmp"
            echo "Download failed, keeping existing blacklist" >&2
            exit 1
          fi
        '';
      };

      systemd.timers.update-dnscrypt-blacklist = {
        description = "Daily update of dnscrypt-proxy blacklist";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
      };
    };
}
