_: {
  flake.modules.nixos.host-millet =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      grocyHost = "grocy.agarmu.com";
      grocyDataDir = "/var/lib/grocy";
      grocyPhpListen = "127.0.0.1:9001";
      grocyPackage = pkgs.grocy;
    in
    {
      environment.etc."grocy/config.php".text = ''
        <?php
        Setting('CULTURE', 'en');
        Setting('CURRENCY', 'USD');
        Setting('CALENDAR_FIRST_DAY_OF_WEEK', "");
        Setting('CALENDAR_SHOW_WEEK_OF_YEAR', ${lib.boolToString true});
        Setting('ENTRY_PAGE', 'stock');
      '';

      users.users.grocy = {
        isSystemUser = true;
        createHome = true;
        home = grocyDataDir;
        group = config.services.caddy.group;
      };

      systemd.tmpfiles.rules =
        lib.map (dirName: "d '${grocyDataDir}/${dirName}' - grocy ${config.services.caddy.group} - -")
          [
            "viewcache"
            "plugins"
            "settingoverrides"
            "storage"
          ];

      services.phpfpm.pools.grocy = {
        user = "grocy";
        group = config.services.caddy.group;

        inherit (grocyPackage.passthru) phpPackage;

        settings = {
          "pm" = "dynamic";
          "php_admin_value[error_log]" = "stderr";
          "php_admin_flag[log_errors]" = true;
          "catch_workers_output" = true;
          "pm.max_children" = "32";
          "pm.start_servers" = "2";
          "pm.min_spare_servers" = "2";
          "pm.max_spare_servers" = "4";
          "pm.max_requests" = "500";
          "listen" = grocyPhpListen;
        };

        phpEnv = {
          GROCY_CONFIG_FILE = "/etc/grocy/config.php";
          GROCY_DB_FILE = "${grocyDataDir}/grocy.db";
          GROCY_STORAGE_DIR = "${grocyDataDir}/storage";
          GROCY_PLUGIN_DIR = "${grocyDataDir}/plugins";
          GROCY_CACHE_DIR = "${grocyDataDir}/viewcache";
        };
      };

      # After a grocy update, clear the compiled templates before php-fpm starts.
      systemd.services.grocy-setup = {
        wantedBy = [ "multi-user.target" ];
        before = [ "phpfpm-grocy.service" ];
        unitConfig.RequiresMountsFor = [ grocyDataDir ];
        script = ''
          rm -rf ${grocyDataDir}/viewcache/*
        '';
      };

      services.caddy.virtualHosts."${grocyHost}" = {
        extraConfig = ''
          root * ${grocyPackage}/public
          php_fastcgi ${grocyPhpListen}
          file_server
        '';
      };
    };
}
