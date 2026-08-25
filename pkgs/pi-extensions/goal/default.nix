{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "pi-goal";
  version = "unstable";
  npmWorkspace = "packages/pi-goal";
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-gquPyRukV8ZSwjd/61bruITc6RYA23+n2eqwq1L5b0c=";
  src = fetchFromGitHub {
    owner = "narumiruna";
    repo = "pi-extensions";
    rev = "main";
    hash = "sha256-vGe6lpSrk+TcwPA1O41VTP1r1HatdKC7mE11JTdueic=";
  };
  postInstall = ''
    cp -r "$out/lib/node_modules/pi-extensions/." "$out/"
    rm -rf "$out/lib"
    find "$out" -xtype l -delete
  '';
  meta = with lib; {
    description = "Codex-like verified /goal workflow for Pi";
    homepage = "https://github.com/narumiruna/pi-extensions";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
