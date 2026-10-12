{
  lib,
  buildNpmPackage,
  cacert,
  fetchgit,
  nodejs_26,
  python3,
  python3Packages,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "zotero-better-bibtex";
  version = "9.0.71";

  src = fetchgit {
    url = "https://github.com/retorquere/zotero-better-bibtex.git";
    rev = "d1b4df51a7a028d986d8ba3079675059200fa074";
    fetchSubmodules = true;
    hash = "sha256-vTAFwebNJ0jY4eEy0xoFnvCV5lmLluqPu9hVG8exgi0=";
  };

  postPatch = ''
    # submodules.py is a dev maintenance script, not needed for building
    substituteInPlace setup/setup.py --replace-fail "import submodules" ""
  '';

  nodejs = nodejs_26;

  makeCacheWritable = true;

  npmDepsHash = "sha256-V+0RdEdyxtwI67b9iXJEANefZaUVGQ8+h7lZt+NInbk=";

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
    install -m444 -D xpi/*.xpi $out/share/zotero/extensions/zotero-better-bibtex.xpi
    runHook postInstall
  '';

  passthru.extensionId = "better-bibtex@iris-advies.com";

  passthru.updateScript = nix-update-script {
    attrPath = "zotero-addons.zotero-better-bibtex";
    extraArgs = [
      "--version=branch"
      "--flake"
    ];
  };

  meta = with lib; {
    description = "Make Zotero useful for us LaTeX holdouts";
    homepage = "https://retorque.re/zotero-better-bibtex";
    license = licenses.isc;
    platforms = platforms.all;
  };
}
