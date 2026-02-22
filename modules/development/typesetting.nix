_: {
  flake.modules.homeManager.base = _: {
    programs.pandoc.enable = true;
  };
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.texlive = {
        enable = true;
        extraPackages = t: {
          inherit (t) scheme-full;
        };
      };
      home.packages = with pkgs; [
        texlab # LaTeX LSP
        ltex-ls # grammar/spell checking LSP (LanguageTool)
        tex-fmt # LaTeX formatter
        tectonic # self-contained LaTeX engine
        detex # strip LaTeX to plain text (word counts, linting)
        vale # prose linter (style guide enforcement)
        typst # modern typesetting
        tinymist # Typst LSP
      ];
    };
}
