{ lib, ... }: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ghostscript
        ocrmypdf
        pdftk
        qpdf
        poppler-utils
      ];
    };
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.pdfarranger
      ];
      stylix.targets.sioyek.enable = false;
      programs.sioyek = {
        enable = true;
        package = pkgs.sioyek.overrideAttrs (
          prevAttrs:
          lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
            nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.llvmPackages.lld ];
            env = {
              # Work around ld64's libc++ hardening issue.
              # TODO: Remove once #536365 reaches this branch.
              NIX_CFLAGS_LINK = "-fuse-ld=lld";
            };
          }
        );
        config = {
          should_launch_new_window = "1";
          page_separator_width = "5";
          page_separator_color = "0.9 0.9 0.9";
          new-instance = "1";
        };
      };
    };
  flake.modules.homeManager.darwin = { pkgs, ... }: {
    home.packages = [
      # TODO: change back when https://github.com/NixOS/nixpkgs/pull/544437 hits unstable
      (pkgs.skimpdf.overrideAttrs (prevAttrs: {
        nativeBuildInputs = (prevAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];

        postInstall = (prevAttrs.postInstall or "") + ''
          install -d "$out/bin"
          for app in displayline skimnotes skimpdf; do
            makeWrapper "$out/Applications/Skim.app/Contents/SharedSupport/$app" "$out/bin/$app"
          done
        '';
      }))
    ];
  };
  flake.modules.homeManager.linuxGui = { pkgs, ... }: {
    home.packages = [ pkgs.kdePackages.okular ];
    xdg.mimeApps.defaultApplications = {
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "application/x-bzpdf" = [ "org.kde.okular.desktop" ];
      "application/x-gzpdf" = [ "org.kde.okular.desktop" ];
      "application/x-xzpdf" = [ "org.kde.okular.desktop" ];
      "application/x-ext-pdf" = [ "org.kde.okular.desktop" ];
    };
  };
}
