{ inputs, ... }:
{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.firefox.profiles.default.extensions = {
        force = true;
        packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          bitwarden
          zotero-connector
        ];
      };
    };
}
