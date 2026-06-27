{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      inherit (pkgs)
        stdenv
        desktopToDarwinBundle
        lndir
        makeBinaryWrapper
        ;
      pkg = pkgs.thorium-reader;
      thorium-wrapped =
        if pkgs.stdenv.isDarwin then
          stdenv.mkDerivation {
            pname = "${pkg.pname or pkg.name}-darwin-bundle";
            version = pkg.version or "unknown";

            # Include lndir for symlinking and the setup hook to generate the bundle
            nativeBuildInputs = [
              lndir
              desktopToDarwinBundle
              makeBinaryWrapper
            ];

            dontUnpack = true;
            dontStrip = true;

            installPhase = ''
              mkdir -p $out
              # Recursively symlink the original package contents into this derivation.
              # This perfectly mirrors the behavior of symlinkJoin.
              lndir -silent ${pkg} $out

              # use a binary wrapper
              exeName=${pkg.meta.mainProgram or pkg.pname or pkg.name}

              if [ -L "$out/bin/$exeName" ]; then
                rm "$out/bin/$exeName"

                # makeWrapper (intercepted by makeBinaryWrapper) compiles a C executable
                # that forwards execution to the original package's script.
                makeWrapper "${pkg}/bin/$exeName" "$out/bin/$exeName"
              else
                echo "Error: Expected executable $exeName not found in $out/bin/"
                exit 1
              fi
            '';
          }
        else
          pkg;
    in
    {
      programs.foliate = {
        enable = pkgs.stdenv.isLinux;
      };
      home.packages = [ thorium-wrapped ];
      programs.calibre = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then pkgs.mukul.calibre-bin else pkgs.calibre-no-speech;
      };
    };

}
