{
  config,
  pkgs,
  ...
}: let
  buildFirefoxXpiAddon = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon;
  zotero-connector = buildFirefoxXpiAddon {
    pname = "zotero-connector";
    version = "5.0.114";
    addonId = "zotero@chnm.gmu.edu";
    url = "https://download.zotero.org/connector/firefox/release/Zotero_Connector-5.0.114.xpi";
    sha256 = "1c66d8fccbdc7096cfc5b4b5f250c4249fbe48395c1b944d2fd26d52434a2dbd";
    meta = {};
  };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.runCommand "firefox-0.0.0" {} "mkdir $out";
    profiles = let
      userChrome = builtins.readFile ./userChrome.css;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
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
        bypass-paywalls-clean
        unpaywall
        sidebery
        profile-switcher
      ];
    in {
      default = {
        inherit extensions userChrome;
        id = 0;
      };
      puhack = {
        inherit extensions userChrome;
        id = 1;
      };
    };
  };
}
