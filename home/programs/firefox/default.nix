{
  config,
  pkgs,
  nur,
  ...
}: let
  buildFirefoxXpiAddon = nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon;
  zotero-connector = buildFirefoxXpiAddon {
    pname = "zotero-connector";
    version = "5.0.114";
    addonId = "zotero@chnm.gmu.edu";
    url = "https://download.zotero.org/connector/firefox/release/Zotero_Connector-5.0.114.xpi";
    sha256 = "1c66d8fccbdc7096cfc5b4b5f250c4249fbe48395c1b944d2fd26d52434a2dbd";
    meta = {};
  };
  dark-space = buildFirefoxXpiAddon {
    pname = "Dark-Space";
    version = "1.1.1";
    addonId = "{22b0eca1-8c02-4c0d-a5d7-6604ddd9836e}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3765900/nicothin_space-1.1.1.xpi";
    sha256 = "f148cb25908af1401075db75bf145751eb4b6fa05823126bea89a1a14da5ee54";
    meta = {};
  };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.runCommand "firefox-0.0.0" {} "mkdir $out";
    profiles = let
      userChrome = builtins.readFile ./userChrome.css;
      extensions = []; # TODO: FIX
      /*
        extensions = with nur.repos.rycee.firefox-addons; [
        auto-tab-discard
        brandon1024-find
        cliget
        clearurls
        onepassword-password-manager
        privacy-pass
        facebook-container
        multi-account-containers
        refined-github
        ublock-origin
        wayback-machine
        youtube-recommended-videos
        zotero-connector
        dark-space
      ];
      */
    in {
      default = {
        inherit extensions;
      };
    };
  };
}
