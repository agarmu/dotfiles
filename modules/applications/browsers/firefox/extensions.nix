{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.firefox =
        let
          addons = pkgs.nur.repos.rycee.firefox-addons;
        in
        {
          globalExtensions = with addons; [
            ublock-origin
            cliget
          ];
          profiles.default.extensions = {
            force = true;
            packages = with addons; [
              bitwarden
              web-archives
              zotero-connector
              bypass-paywalls-clean
            ];
          };
        };
    };
}
