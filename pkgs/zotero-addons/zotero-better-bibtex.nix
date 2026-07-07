{
  lib,
  buildNpmPackage,
  cacert,
  fetchgit,
  nodejs_26,
  python3,
  python3Packages,
}:

buildNpmPackage rec {
  pname = "zotero-better-bibtex";
  version = "9.0.36";

  src = fetchgit {
    url = "https://github.com/retorquere/zotero-better-bibtex.git";
    rev = "cfde2a84ce64a12eb3c287d8db460f8671745ba0";
    fetchSubmodules = true;
    hash = "sha256-yB0rfjuDfxFnPjnJ4AMkGuVKvROlcyM/g0NkZfdbCMM=";
  };

  postPatch = ''
    # submodules.py is a dev maintenance script, not needed for building
    substituteInPlace setup/setup.py --replace-fail "import submodules" ""
  '';

  nodejs = nodejs_26;

  makeCacheWritable = true;

  npmDepsHash = "sha256-tWkCpO5LU2KDsyJMw1ZCKPOcbd6PhR4GAQdxtdC8cjU=";

  buildPhase = ''
    runHook preBuild
    export PATH=$PWD/node_modules/.bin:$PATH
    npm run setup
    run-p --aggregate-output esbuild tsc
    npm run zipup-better-bibtex
    runHook postBuild
  '';

  nativeBuildInputs = [
    cacert
    python3
    python3Packages.fluent-syntax
    python3Packages.fluent-runtime
    python3Packages.javaproperties
    python3Packages.lxml
    python3Packages.mako
    python3Packages.munch
    python3Packages.pytablewriter
    python3Packages.python-dotenv
    python3Packages.rnc2rng
    python3Packages.setuptools
    python3Packages.xmltodict
  ];

  NODE_OPTIONS = "--use-openssl-ca";

  installPhase = ''
    runHook preInstall
    install -m444 -D xpi/*.xpi $out/share/zotero/addons/zotero-better-bibtex.xpi
    runHook postInstall
  '';

  meta = with lib; {
    description = "Make Zotero useful for us LaTeX holdouts";
    homepage = "https://retorque.re/zotero-better-bibtex";
    license = licenses.isc;
    platforms = platforms.all;
  };
}
