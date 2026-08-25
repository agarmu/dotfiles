{
  lib,
  python3,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  jq,
  libnotify,
}:

let
  version = "0-unstable-2026-08-04";
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "niri-tweaks";

  src = fetchFromGitHub {
    owner = "heyoeyo";
    repo = "niri_tweaks";
    rev = "3fd68a1598bd1fac8a7578a09aa9a9b36e19996d";
    hash = "sha256-DRqUvQ0ZPCnLZYJnB71X4AXYt39e8PPHUsMy1cT8oGI=";
  };

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ python3 ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"

    for script in "$src"/*.py "$src"/*.sh; do
      name="$(basename "$script")"
      name="''${name%.py}"
      name="''${name%.sh}"
      cp "$script" "$out/bin/$name"
      chmod +x "$out/bin/$name"
    done

    for f in "$out/bin"/*; do
      wrapProgram "$f" --prefix PATH : "${
        lib.makeBinPath [
          jq
          libnotify
        ]
      }"
    done

    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    for script in "$src"/*.py; do
      ${python3}/bin/python3 -c "import ast; ast.parse(open('$script').read())"
    done

    for script in "$src"/*.sh; do
      bash -n "$script"
    done

    runHook postCheck
  '';

  meta = {
    description = "Helper scripts for additional functionality when using niri";
    homepage = "https://github.com/heyoeyo/niri_tweaks";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };

  passthru.updateScript = nix-update-script {
    attrPath = "niri-tweaks";
    extraArgs = [
      "--flake"
      "--version=branch"
    ];
  };
}
