{
  callPackage,
  haskell,
  haskellPackages,
}:
haskellPackages.override {
  overrides = final: prev: {
    Color = callPackage ./color.nix { haskellPackages = final; };

    freetype2 = callPackage ./freetype2.nix { haskellPackages = final; };

    hip = callPackage ./hip.nix { haskellPackages = final; };

    # Required by the freetype2 fork and pinned by Perspec upstream.
    storable-offset = haskell.lib.doJailbreak (haskell.lib.unmarkBroken prev.storable-offset);
  };
}
