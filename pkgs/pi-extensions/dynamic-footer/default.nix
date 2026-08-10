{
  lib,
  buildNpmPackage,
  fetchurl,
}:

buildNpmPackage rec {
  pname = "pi-dynamic-footer";
  version = "0.1.7";

  src = fetchurl {
    url = "https://registry.npmjs.org/@juanbenjumea/pi-dynamic-footer/-/pi-dynamic-footer-${version}.tgz";
    hash = "sha256-pkWhWVL+kGT/e4h1UPaa3/vUpkSi8fCnKBpOm0ym3hw=";
  };

  npmDepsHash = "sha256-zlbsiW40JAqcjrjU84zkob9W521e/KQrwcBgfGCh2PU=";
  dontNpmBuild = true;
  dontNpmPrune = true;
  npmInstallFlags = [ "--legacy-peer-deps" ];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json

    # The npm tarball ships TypeScript sources but uses emitted-JavaScript
    # import suffixes. Pi loads source directly, so point those imports at .ts.
    grep -rl --include='*.ts' '\.js"' . | while read -r file; do
      substituteInPlace "$file" --replace-warn '.js"' '.ts"'
    done
  '';

  postInstall = ''
    cp -r "$out/lib/node_modules/@juanbenjumea/pi-dynamic-footer/." "$out/"
    # npm's global install omits this package's nested TypeScript source tree.
    rm -rf "$out/lib"
    cp -r lib "$out/"
  '';

  meta = with lib; {
    description = "Dynamic configurable footer with context, usage, cost, and Git observability for Pi";
    homepage = "https://github.com/juanbenjumea/dotfiles/tree/main/pi/packages/pi-dynamic-footer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
