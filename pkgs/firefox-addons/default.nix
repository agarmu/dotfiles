{
  build-support,
  callPackage,
}:

let
  inherit (build-support) buildFirefoxXpiAddon;
in
{
  inherit buildFirefoxXpiAddon;

  bitwarden = callPackage ./bitwarden { inherit buildFirefoxXpiAddon; };
  cliget = callPackage ./cliget { inherit buildFirefoxXpiAddon; };
  ublock-origin = callPackage ./ublock-origin { inherit buildFirefoxXpiAddon; };
  web-archives = callPackage ./web-archives { inherit buildFirefoxXpiAddon; };
  xcancel = callPackage ./xcancel { inherit buildFirefoxXpiAddon; };
  zotero-connector = callPackage ./zotero-connector { inherit buildFirefoxXpiAddon; };
}
