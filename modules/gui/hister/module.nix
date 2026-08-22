{ lib, ... }: {
  flake.modules.homeManager.gui =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.services.hister;
      yaml = pkgs.formats.yaml { };
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      isLinux = pkgs.stdenv.hostPlatform.isLinux;
      configPath =
        if isDarwin then
          "${config.home.homeDirectory}/Library/Preferences/hister/config.yml"
        else
          "${config.xdg.configHome}/hister/config.yml";
      dataDirectory =
        if isDarwin then
          "${config.home.homeDirectory}/Library/Application Support/hister"
        else
          "${config.xdg.stateHome}/hister";
      generatedConfig = yaml.generate "hister-config.yml" (
        lib.recursiveUpdate cfg.settings { server.base_url = cfg.url; }
      );
      generatedTuiConfig = yaml.generate "hister-tui.yaml" cfg.tuiSettings;
    in
    {
      options.services.hister = {
        enable = lib.mkEnableOption "Hister search service";

        url = lib.mkOption {
          type = lib.types.nonEmptyStr;
          description = "Public base URL for Hister.";
        };

        settings = lib.mkOption {
          inherit (yaml) type;
          default = {
            app = {
              directory = dataDirectory;
              title = "Hister";
              subtitle = "Your own search engine";
              color_scheme = "automatic";
              search_url = "https://google.com/search?q={query}";
              access_token = "";
              user_handling = false;
              public = false;
              log_level = "info";
              log_file = "";
              log_format = "text";
              debug_sql = false;
              open_results_on_new_tab = false;
              redirect_on_no_results = true;
              display_extractor_config = false;
              disable_previews = false;
              profiler = false;
            };
            server = {
              address = "127.0.0.1:4433";
              database = "db.sqlite3";
              max_batch_body_size = 40;
              oauth = { };
              oauth_only = false;
            };
            indexer = {
              detect_languages = true;
              keep_stopwords = false;
              directories = [ ];
              max_file_size_mb = 1;
            };
            crawler = {
              timeout = 5;
              delay = 0;
              backend = "http";
              backend_options = { };
              proxy = "";
              user_agent = "";
              headers = { };
              cookies = [ ];
              no_robots = false;
            };
            semantic_search = {
              enable = false;
              embedding_endpoint = "http://localhost:11434/v1/embeddings";
              embedding_model = "qwen3-embedding:8b";
              embedding_timeout = 300;
              api_key = "";
              headers = { };
              dimensions = 4096;
              max_context_length = 512;
              chunk_overlap = 64;
              max_embedding_batch_size = 8;
              query_prefix = "query: ";
              document_prefix = "";
              similarity_threshold = 0.1;
              result_limit = 50;
              semantic_weight = 0.4;
              max_embedding_concurrency = 2;
            };
            hotkeys = {
              web = {
                "/" = "focus_search_input";
                "?" = "show_hotkeys";
                "alt+d" = "delete_result";
                "alt+enter" = "open_result_in_new_tab";
                "alt+j" = "select_next_result";
                "alt+k" = "select_previous_result";
                "alt+o" = "open_query_in_search_engine";
                "alt+v" = "view_result_popup";
                enter = "open_result";
                tab = "autocomplete";
              };
            };
            sensitive_content_patterns = {
              aws_access_key = "(^|[\\s\"'])AKIA[0-9A-Z]{16}([\\s\"']|$)";
              aws_secret_key = "(?i)aws(.{0,20})?(secret)?(.{0,20})?['\"][0-9a-zA-Z\\/+]{40}['\"]";
              generic_private_key = "-----BEGIN ((RSA|EC|DSA) )?PRIVATE KEY-----";
              github_token = "(ghp|gho|ghu|ghs|ghr)_[a-zA-Z0-9]{36}";
              pgp_private_key = "-----BEGIN PGP PRIVATE KEY BLOCK-----";
              ssh_private_key = "-----BEGIN OPENSSH PRIVATE KEY-----";
            };
            extractors = { };
          };
          description = "Hister configuration written to the platform's preferred configuration directory.";
        };

        tuiSettings = lib.mkOption {
          inherit (yaml) type;
          default = {
            dark_theme = "tokyonight";
            light_theme = "catppuccin-latte";
            color_scheme = "auto";
            hotkeys = {
              "ctrl+c" = "quit";
              f1 = "toggle_help";
              tab = "toggle_focus";
              esc = "toggle_focus";
              up = "scroll_up";
              k = "scroll_up";
              down = "scroll_down";
              j = "scroll_down";
              enter = "open_result";
              y = "copy_result";
              v = "toggle_preview";
              l = "edit_label";
              "ctrl+d" = "delete_result";
              "ctrl+t" = "toggle_theme";
              "ctrl+s" = "toggle_settings";
              "ctrl+o" = "toggle_sort";
              "ctrl+e" = "toggle_semantic";
              "alt+1" = "tab_search";
              "alt+2" = "tab_history";
              "alt+3" = "tab_rules";
              "alt+4" = "tab_add";
            };
          };
          description = "Hister TUI configuration written to tui.yaml.";
        };
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          {
            assertions = [
              {
                assertion = isDarwin || isLinux;
                message = "services.hister supports only macOS and Linux.";
              }
            ];

            home.packages = [ pkgs.hister ];
          }

          (lib.mkIf isDarwin {
            launchd.agents.hister = {
              enable = true;
              config = {
                Label = "hister";
                ProgramArguments = [
                  "${pkgs.hister}/bin/hister"
                  "listen"
                  "--config"
                  configPath
                ];
                RunAtLoad = true;
                KeepAlive = true;
              };
            };

            home.file = {
              "Library/Preferences/hister/config.yml".source = generatedConfig;
              "Library/Preferences/hister/tui.yaml".source = generatedTuiConfig;
            };
          })

          (lib.mkIf isLinux {
            systemd.user.services.hister = {
              Unit = {
                Description = "Hister search service";
                After = [ "network.target" ];
              };
              Service = {
                ExecStart = "${pkgs.hister}/bin/hister listen --config ${lib.escapeShellArg configPath}";
                Restart = "always";
                RestartSec = 5;
              };
              Install.WantedBy = [ "default.target" ];
            };

            xdg.configFile = {
              "hister/config.yml".source = generatedConfig;
              "hister/tui.yaml".source = generatedTuiConfig;
            };
          })
        ]
      );
    };
}
