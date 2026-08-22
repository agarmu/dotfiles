{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.firefox =
        let
          addons = pkgs.firefox-addons;
        in
        {
          globalExtensions = with addons; [
            ublock-origin
            bitwarden
          ];
          profiles.default.extensions = {
            force = true;
            packages = with addons; [
              cliget
              hister
              web-archives
              zotero-connector
              bypass-paywalls-clean
              xcancel
            ];
          };
        };
    };
}
