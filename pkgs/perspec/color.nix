{
  fetchFromGitHub,
  haskell,
  haskellPackages,
}:
let
  src = fetchFromGitHub {
    owner = "lehins";
    repo = "Color";
    rev = "ec833edd8f9b15543855c00826c4ede470773f83";
    hash = "sha256-YCMHje5Rjw07Cv0JXpNPr+Rilk76Rmdaeiwo0dWFjQQ=";
  };
in
haskell.lib.dontCheck (haskellPackages.callCabal2nix "Color" "${src}/Color" { })
