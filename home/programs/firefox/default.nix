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
  bpc = buildFirefoxXpiAddon {
    pname = "bypass-paywalls-clean";
    version = "3.6.5.0";
    addonId = "bpc@bpc.bpc";
    url =
      "https://github.com/bpc-clone/bpc_updates/releases/download/latest/bypass_paywalls_clean-3.7.1.0.xpi";
    sha256 = "7173c80c3dcf59f81e7804da15452346f428a944fbeedecf64cdc9e927f5d940";
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
        bpc # TODO:bypass-paywalls-clean
        unpaywall
        sidebery
        profile-switcher
      ];
    in {
      default = {
        inherit extensions userChrome;
        id = 0;
      };
      personal-2 = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons;
          [ onepassword-password-manager ublock-origin clearurls ];
        inherit userChrome;
        id = 2;
      };
    };
  };
}
