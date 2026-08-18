{ callPackage }:

{
  buildFirefoxXpiAddon = callPackage ./buildFirefoxXpiAddon.nix { };

  buildHelixPlugin = callPackage ./buildHelixPlugin.nix { };

  installRustCdylibHook = callPackage ./installRustCdylibHook.nix { };

}
