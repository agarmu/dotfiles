{ callPackage }:

{
  fontCheckHook = callPackage ./font-check-hook { };
  plist-font-patcher = callPackage ./plist-font-patcher { };

  buildFirefoxXpiAddon = callPackage ./buildFirefoxXpiAddon.nix { };

}
