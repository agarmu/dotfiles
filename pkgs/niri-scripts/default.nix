{
  lib,
  fetchFromGitHub,
  rustPlatform,
  runCommand,
  makeWrapper,
  awww,
  grim,
  satty,
  slurp,
  wl-clipboard,
}:

let
  rawSrc = fetchFromGitHub {
    owner = "0xwal";
    repo = "niri-scripts";
    rev = "37ad621e7f2b4e24c3135950b8e5369d398a2d5c";
    hash = "sha256-4i371yWVI3UyIzahpcWPBBJqZNH0QE47fi1+lMkgsi0=";
  };

  src = runCommand "niri-scripts-src" { } ''
    mkdir -p $out/src

    for script in support-sticky-floating wallpaper-per-workspace screenshot; do
      awk '/^\/\/ scriptisto-end$/{found=1; next} found{print}' \
        "${rawSrc}/$script" > "$out/src/$script.rs"
    done

    substituteInPlace $out/src/wallpaper-per-workspace.rs \
      --replace-fail '"swww"' '"awww"'

    cp ${./Cargo.toml} $out/Cargo.toml
    cp ${./Cargo.lock} $out/Cargo.lock
  '';

  runtimePath = lib.makeBinPath [
    awww
    grim
    satty
    slurp
    wl-clipboard
  ];
in
rustPlatform.buildRustPackage {
  pname = "niri-scripts";
  version = "unstable-2026-04-26";

  inherit src;
  cargoHash = "sha256-5FZKPRm5oQWtnZk7/REX8xkkxCtc5JiRq8TAOvAAavM=";

  env.RUSTFLAGS = "--cap-lints allow";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram "$f" --prefix PATH : "${runtimePath}"
    done

    makeWrapper $out/bin/support-sticky-floating $out/bin/toggle-sticky \
      --add-flags toggle-sticky \
      --prefix PATH : "${runtimePath}"
  '';

  meta = {
    description = "Scripts to extend niri functionality";
    homepage = "https://github.com/0xwal/niri-scripts";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
