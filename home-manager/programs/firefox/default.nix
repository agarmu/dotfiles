{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.runCommand "firefox-0.0.0" {} "mkdir $out";
    profiles = let
      userChrome = builtins.readFile ./userChrome.css;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        brandon1024-find
        flagfox
        cliget
        clearurls
        firemonkey
        onepassword-password-manager
        privacy-badger
        privacy-pass
        ublock-origin
        wayback-machine
        youtube-recommended-videos
      ];
      # Much of hardening settings adopted from https://brainfucksec.github.io/firefox-hardening-guide
      settings = {
        # Disables about:config warnings
        "browser.aboutConfig.showWarning" = false;

        ####################
        # Startup Settings #
        ####################

        # Use the default Firefox startup page
        "browser.startup.page" = 1;
        "browser.startup.homepage" = "about:home";

        # Disables Activity Stream on new windows and tab pages
        "browser.newtabpage.enabled" = false;
        "browser.newtab.preload" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";
        ###############
        # Geolocation #
        ###############
        # Use Mozilla geolocation service instead of Google if permission is granted
        "geo.provider.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        # Disables using the OS’s geolocation service
        "geo.provider.use_corelocation" = false;
        "geo.provider.use_gpsd" = false;
        "geo.provider.use_geoclue" = false;

        ###################
        # Language/Locale #
        ###################
        "intl.accept_languages" = "en-US, en";
        "javascript.use_us_english_locale" = true;

        #################
        # Auto-Updating #
        #################
        # Do not auto-update
        "app.update.background.scheduling.enable" = false;
        "app.update.auto" = false;

        # Disables addons recommendations (uses Google Analytics)
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;

        #############
        # Telemetry #
        #############
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "browser.ping-centre.telemetry" = false;
        "beacon.enabled" = false;

        ###########
        # Studies #
        ###########
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        #################
        # Crash reports #
        #################

        # Disables sending Crash Reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;

        #############################################
        # Captive Portal Detection / Network Checks #
        #############################################

        # Disables captive portal detection
        "captivedetect.canonicalUR" = "";
        "captive-portal-service.enabled" = false;

        # Disables Network Connections Checks
        "connectivity-service.enabled" = false;

        #################
        # Safe Browsing #
        #################
        # Disables safe browsing service
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        # Disables list of blocked URIs
        "browser.safebrowsing.blockedURIs.enabled" = false;
        # Disables fetching updates
        "browser.safebrowsing.provider.google4.gethashURL" = "";
        "browser.safebrowsing.provider.google4.updateURL" = "";
        "browser.safebrowsing.provider.google4.dataSharingURL" = "";
        "browser.safebrowsing.provider.google.gethashURL" = "";
        "browser.safebrowsing.provider.google.updateURL" = "";
        "browser.safebrowsing.provider.google.dataSharingURL" = "";
        # Disables checks for downloads
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = "";
        # Disables checks for unwanted software
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        # Disables bypasses the block of safe browsing with a click for current session
        "browser.safebrowsing.allowOverride" = false;
        #############################
        # Network: DNS, Proxy, IPv6 #
        #############################
        # Disables link prefetching
        "newtwork.prefetch-next" = false;
        # Disables DNS prefetching
        "newtwork.dns.disablePrefetch" = true;
        # Disables predictor
        "newtwork.predictor.enabled" = false;
        # Disables link-mouseover opening connection to linked server
        "newtwork.http.speculative-parallel-limit" = 0;
        # Disables mousedown speculative connections on bookmarks and history
        "newtwork.browser.places.speculativeConnect.enabled" = false;
        # Disables GIO protocols as a potential proxy bypass vectors
        "newtwork.gio.supported-protocols" = "";
        # Disables using UNC (Uniform Naming Convention) paths (prevent proxy bypass)
        "newtwork.file.disable_unc_paths" = true;
        # Enables Punycode in Internationalized Domain Names to eliminate possible spoofing
        "newtwork.IDN_show_punycode" = true;
        # Removes special permissions for certain mozilla domains
        "permissions.manager.defaultsUrl" = "";

        #####################################
        # Search Bar: Suggestions, Autofill #
        #####################################
        # Disables location bar for domain guessing
        "browser.fixup.alternate.enabled" = false;
        # Disables search suggestions
        "browser.search.suggest.enabled" = false;
        # Disables URL bar search suggestions
        "browser.urlbar.suggest.searches" = false;
        # Disables URL Bar quicksuggest
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        # Displays all parts of the url in the bar
        "browser.urlbar.trimURLs" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        # Disable location bar contextual suggestions
        "browser.urlbar.quicksuggest.scenario" = "history";
        "browser.urlbar.quicksuggest.enabled" = false;
        # Disables form autofill
        "browser.formfill.enable" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
        #############
        # Passwords #
        #############
        # Disables saving passwords
        "signon.rememberSignons" = false;
        # Disables autofill login and passwords
        "signon.autofillForms" = false;
        # Disables formless login capture for Password Manager
        "signon.formlessCapture.enabled" = false;
        # Prevents cross-origin sub-resources to open HTTP authentication credentials dialogs
        "network.auth.subresource-http-auth-allow" = 1;

        #######################
        # Disk Cache / Memory #
        #######################
        # Disables Disk Cache
        "browser.cache.disk.enable" = false;
        # Disables storing extra session data
        "browser.sessionstoreprivacy_level" = 2;
        # Disables resuming session from crash
        "browser.sessionstoreresume_from_crash" = false;
        # Disable page thumbnail collection
        "browser.pagethumbnails.capturing_disabled" = true;
        # Disable favicons in profile folder
        "browser.shell.shortcutFavicons" = false;
        # Deletes temporary files opened with external apps
        "browser.helperApps.deleteTempFileOnExit" = true;
        ##################################
        # HTTPS / SSL/TLS / OSCP / CERTS #
        ##################################
        # Enables HTTPS-Only mode in all windows
        "down.security.https_only_mode" = true;
        # Disables sending HTTP request for checking HTTPS support by the server:
        "down.security.https_only_mode_send_http_background_request" = false;

        # Displays advanced information on Insecure Connection warning pages
        "browser.xul.error_pages.expert_bad_cert" = true;

        # Disables TLS1.3 0-RTT (round-trip time)
        "security.tls.enable_0rtt_data" = false;
        # Set OCSP to terminate the connection when a CA isn’t validate
        "security.OCSP.require" = true;
        # Disables SHA1 Certificates
        "security.pki.sha1_enforcement_level" = 1;
        # Enables strict key pinning
        "security.cert_pinning.enforcement_level" = 2;
        # Enables CRLite
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;
        ######################
        # Headers / Referers #
        ######################
        # Send referer only if hosts match
        "network.http.referer.XOriginPolicy" = 2;
        # Send only scheme + host + port to referer
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        #####################
        # Audio/Video/Media #
        #####################

        # Do not autoplay HTML5 Media
        "media.autoplay.default" = 5;

        #############
        # Downloads #
        #############
        # Always ask to save files
        "browser.download.useDownloadDir" = false;
        # Do not add downloads to recent documents
        "browser.download.manager.addToRecentDocs" = false;
        ###########
        # Cookies #
        ###########

        # Enables ETP (Enhanced Tracking Protection)
        # This also enables TCP (Total Cookie Protection)
        "browser.contentblocking.category" = "strict";

        # Enables state partitioning of service workers
        "privacy.partition.serviceWorkers" = true;

        # Enables APS (Always Partitioning Storage)
        "privacy.partition.always_partition_third_party_non_cookie_storage.enable" = true;
        "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = true;

        ###############
        # UI Features #
        ###############
        # Disables Pocket extension
        "extensions.pocket.enabled" = false;
        # Disables Screenshots extension
        "extensions.Screenshots.disabled" = true;
        # Disable PDJFS scripting:
        "pdfjs.enableScripting" = false;
        # Enables Containers and show the UI settings
        "privacy.userContext.enabled" = true;

        ##############
        # Extensions #
        ##############

        # Always display the installation prompt
        "extensions.postDownloadThirdPartyPrompt" = false;

        ##################
        # Fingerprinting #
        ##################
        # Enables RFP
        "privacy.resistFingerprinting" = true;
        # Disables mozAddonManager Web API
        "privacy.resistFingerprinting.block_mozAddonManager" = true;
        # Sets new window size rounding max values
        "privacy.window.maxInnerWidth" = 1600;
        "privacy.window.maxInnerHeight" = 900;
        # Disables using system colors:
        "browser.display.use_system_colors" = false;
        # Disable showing about:blank page when possible at startup
        "browser.startup.blankWindow" = false;
      };
    in {
      home = {
        inherit extensions settings;
      };
    };
  };
}
