{
  fetchFromGitHub,
  haskell,
  haskellPackages,
}:
let
  # Match the maintained fork pinned by upstream. Hackage's freetype2 release
  # bundles an obsolete zlib that fails with current Apple SDKs.
  src = fetchFromGitHub {
    owner = "dpwiz";
    repo = "freetype2";
    rev = "d2acf926b5c448d8edd60e322862adcf2dbe9146";
    hash = "sha256-KR/EklKbCfocQj7/fkiY80D0wZ2ZrgckmGuZN08qWMI=";
  };
in
haskell.lib.dontCheck (haskellPackages.callCabal2nix "freetype2" src { })
