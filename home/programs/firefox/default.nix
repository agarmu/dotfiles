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
    url = "https://github.com/bpc-clone/bpc_updates/releases/download/latest/bypass_paywalls_clean-3.6.5.0.xpi";
    sha256 = "8d03b968b11edd546fe128ff2ded1fdcd660f0f835e572df6170cf538d02b8c3";
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
      puhack = {
        inherit extensions userChrome;
        id = 1;
      };
    };
  };
}
