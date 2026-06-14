{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.firefox.profiles.default.extensions = {
        force = true;
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          web-archives
          zotero-connector
        ];
      };
    };
}
