{
  flake.modules.nixos.wifi =
    { config, ... }:
    let
      autoIp = {
        ipv4.method = "auto";
        ipv6 = {
          method = "auto";
          addr-gen-mode = "stable-privacy";
        };
      };
    in
    {
      sops.secrets."wifi/wireless.env" = { };

      networking = {
        wireless.iwd = {
          enable = true;
          settings = {
            Network.EnableIPv6 = true;
            Settings.AutoConnect = true;
            General.EnableNetworkConfiguration = true;
          };
        };
        networkmanager.wifi.backend = "iwd";
      };

      /*
        little utility to connect to `captive`
        browser portals, without ruining our
        dns settings
      */
      programs.captive-browser = {
        enable = true;
        interface = "wlan0";
      };

      networking.networkmanager.ensureProfiles = {
        environmentFiles = [ config.sops.secrets."wifi/wireless.env".path ];
        profiles =
          {
            purdue_apartment = {
              connection = {
                id = "purdue_apartment";
                type = "wifi";
              };
              wifi.ssid = "$purdue_apartment_ssid";
              wifi-security = {
                key-mgmt = "wpa-psk";
                psk = "$purdue_apartment_psk";
              };
            };
            home = {
              connection = {
                id = "home";
                type = "wifi";
              };
              wifi.ssid = "$home_ssid";
              wifi-security = {
                key-mgmt = "wpa-psk";
                psk = "$home_psk";
              };
            };
            purdue_pal3 = {
              connection = {
                id = "purdue_pal3";
                type = "wifi";
              };
              wifi.ssid = "PAL3.0";
              wifi-security.key-mgmt = "wpa-eap";
              "802-1x" = {
                eap = "peap";
                identity = "$purdue_pal3_identity";
                phase2-auth = "mschapv2";
                password = "$purdue_password";
              };
            };
            eduroam = {
              connection = {
                id = "eduroam";
                type = "wifi";
              };
              wifi.ssid = "eduroam";
              wifi-security.key-mgmt = "wpa-eap";
              "802-1x" = {
                eap = "peap";
                identity = "$purdue_eduroam_identity";
                phase2-auth = "mschapv2";
                password = "$purdue_password";
              };
            };
          }
          |> builtins.mapAttrs (_: profile: profile // autoIp);
      };
    };
}
