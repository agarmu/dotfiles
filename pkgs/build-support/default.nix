{ callPackage }:

{
  fontCheckHook = callPackage ./font-check-hook { };

  buildFirefoxXpiAddon = callPackage ./buildFirefoxXpiAddon.nix { };

}
