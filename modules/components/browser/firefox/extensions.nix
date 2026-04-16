{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.firefox.profiles.default.extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          darkreader
          consent-o-matic
          web-archives
          zotero-connector
        ];
      };
    };
}
