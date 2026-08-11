{ callPackage }:

{
  buildFirefoxXpiAddon = callPackage ./buildFirefoxXpiAddon.nix { };

  wrapPiExtension = callPackage ./wrapPiExtension.nix { };
}
