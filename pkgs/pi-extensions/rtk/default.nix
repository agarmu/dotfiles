{
  lib,
  pkgs,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "pi-rtk";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "MasuRii";
    repo = "pi-rtk-optimizer";
    rev = "v${version}";
    hash = "sha256-Cw0oLzVv674vpC3g5oteCNZSkHpfBN+IdnYDbkai4q4=";
  };

  buildInputs = [ pkgs.rtk ];

  # Rewritten commands may contain multiple `rtk` invocations, so make the
  # packaged binary available to the whole shell command.
  patches = [ ./rtk-path.patch ];

  postPatch = ''
    substituteInPlace src/rtk-command-environment.ts \
      --replace-fail '@rtkBinPath@' '${lib.makeBinPath [ pkgs.rtk ]}'
  '';

  # Pi supplies the extension's peer dependencies at runtime.
  installPhase = ''
    runHook preInstall
    cp -r . "$out"
    substituteInPlace "$out/src/rtk-executable-resolver.ts" \
      --replace-fail '"rtk"' '"${lib.getExe pkgs.rtk}"'
    runHook postInstall
  '';

  meta = with lib; {
    description = "RTK command rewriting and tool output compaction extension for Pi";
    homepage = "https://github.com/MasuRii/pi-rtk-optimizer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
