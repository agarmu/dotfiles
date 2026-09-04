{
  fetchFromGitHub,
  haskell,
  haskellPackages,
  stdenvNoCC,
}:
let
  src = fetchFromGitHub {
    owner = "lehins";
    repo = "hip";
    rev = "ddfc77feb21722babccd3b3aa73c4c3d41268f54";
    hash = "sha256-K8D9f+9vz5fGcsRRaNWW3DutzcKHIG3od7sJeoRVXoE=";
  };

  # The pinned commit declares a documentation glob for files that are absent
  # from the repository, which makes Cabal's copy phase fail.
  preparedSrc = stdenvNoCC.mkDerivation {
    pname = "hip-source";
    version = "2.0.0.0";
    inherit src;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -R hip/. "$out"
      chmod -R u+w "$out"
      substituteInPlace "$out/hip.cabal" \
        --replace-fail '                 , images/doc/*.jpg' ""

      runHook postInstall
    '';
  };
in
haskell.lib.dontCheck (haskellPackages.callCabal2nix "hip" preparedSrc { })
