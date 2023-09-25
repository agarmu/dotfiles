{
  config,
  pkgs,
  ...
}: {
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    dejavu_fonts
    lato
    liberation_ttf
    libre-baskerville
    montserrat
    # noto-fonts
    # noto-fonts-emoji

    (
      nerdfonts.override
      {
        fonts = [
          "DroidSansMono"
          "FiraCode"
          "JetBrainsMono"
          "Hack"
        ];
      }
    )
  ];
}
