{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.firefox.globalExtensions = with pkgs.firefox-addons; [
        ublock-origin
        cliget
        bitwarden
        web-archives
        zotero-connector
        bypass-paywalls-clean
      ];
    };
}
