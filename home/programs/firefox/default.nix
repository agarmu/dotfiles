{pkgs, ...}: let
  inherit (pkgs.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
  bpc = buildFirefoxXpiAddon {
    pname = "bypass-paywalls-clean";
    version = "3.6.5.0";
    addonId = "bpc@bpc.bpc";
    url = "https://github.com/bpc-clone/bpc_updates/releases/download/latest/bypass_paywalls_clean-3.7.4.0.xpi";
    sha256 = "3c465ce33f11d6de5ede6f04e6ae46587d48f8c45be3c02dd8d339adbace2c50";
    meta = {};
  };
in {
  programs.firefox = {
    enable = false;
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
        bpc
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
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [onepassword-password-manager ublock-origin clearurls];
        inherit userChrome;
        id = 2;
      };
    };
  };
}
