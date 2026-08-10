{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
}:

buildNpmPackage rec {
  pname = "pi-fff";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "ShpetimA";
    repo = "pi-fff";
    rev = "694837d0644abc8527ebfa3ea50135e0f5d1ece4";
    hash = "sha256-MblEDfRm8veDdy+uVl6qWF0qOdl1zpEl1PzbYSkDUmU=";
  };

  npmDepsHash = "sha256-X/3RsQCaHQ90T4YTnYRvdY71yOhdLCFVHtrP6EZ3+VE=";
  dontNpmBuild = true;
  dontNpmPrune = true;
  npmInstallFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [ jq ];

  # Pi provides peer packages and the TypeScript toolchain at runtime.
  postPatch = ''
    ${jq}/bin/jq '.devDependencies = {}' package.json > package.json.tmp
    mv package.json.tmp package.json
    cp ${./package-lock.json} package-lock.json
  '';

  postInstall = ''
    cp -r "$out/lib/node_modules/pi-fff/." "$out/"
    rm -rf "$out/lib"
  '';

  meta = with lib; {
    description = "FFF-powered fuzzy file resolution, autocomplete, and content search for Pi";
    homepage = "https://github.com/ShpetimA/pi-fff";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
