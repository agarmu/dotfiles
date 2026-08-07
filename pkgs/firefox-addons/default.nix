{ callPackage }:

let
  buildFirefoxXpiAddon = callPackage ./buildFirefoxXpiAddon.nix { };
in
{
  inherit buildFirefoxXpiAddon;

  bitwarden = callPackage ./bitwarden { inherit buildFirefoxXpiAddon; };
  bypass-paywalls-clean = callPackage ./bypass-paywalls-clean { inherit buildFirefoxXpiAddon; };
  cliget = callPackage ./cliget { inherit buildFirefoxXpiAddon; };
  ublock-origin = callPackage ./ublock-origin { inherit buildFirefoxXpiAddon; };
  web-archives = callPackage ./web-archives { inherit buildFirefoxXpiAddon; };
  zotero-connector = callPackage ./zotero-connector { inherit buildFirefoxXpiAddon; };
}
