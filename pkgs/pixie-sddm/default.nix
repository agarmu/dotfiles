{
  stdenv,
  fetchFromGitHub,
  background ? "assets/background.jpg",
  primaryColor ? "#E3E3DC",
  accentColor ? "#A9C78F",
  backgroundColor ? "#1A1C18",
  textColor ? "#E3E3DC",
  fontFamily ? "Google Sans Flex Freeze",
  fontSize ? 12,
}:
stdenv.mkDerivation {
  name = "pixie-sddm";

  src = fetchFromGitHub {
    owner = "xCaptaiN09";
    repo = "pixie-sddm";
    rev = "main";
    sha256 = "sha256-NkjWP/y3kLRjYM0Wr3l7ndbMx3XYxQFXy07C28vrUSU=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes/pixie
    cp -r * $out/share/sddm/themes/pixie/
    rm -r $out/share/sddm/themes/pixie/assets
    printf '%s\n' \
      '[General]' \
      "# Path to the wallpaper. If it's in the assets folder, use \"assets/background.jpg\"" \
      "background=${background}" \
      "" \
      '# Material You-like colors (we can refine these)' \
      "primaryColor=${primaryColor}" \
      "accentColor=${accentColor}" \
      "backgroundColor=${backgroundColor}" \
      "textColor=${textColor}" \
      "" \
      '# Font settings' \
      "fontFamily=${fontFamily}" \
      "fontSize=${toString fontSize}" \
      > $out/share/sddm/themes/pixie/theme.conf
  '';
}
