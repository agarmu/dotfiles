{
  flake.modules.homeManager.base = {
    programs.pandoc.enable = true;
  };
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    let
      texlivePackage = pkgs.texliveFull;
    in
    {
      programs.nixvim.plugins.vimtex = {
        enable = true;
        inherit texlivePackage;
      };
      programs.nixvim.plugins.lsp.servers = {
        texlab.enable = true;
        ltex.enable = true;
        tinymist.enable = true;
        marksman.enable = true;
      };
      programs.zed-editor.extensions = [
        "latex"
        "typst"
      ];
      home.packages = with pkgs; [
        texlivePackage
        texlab # LaTeX LSP
        tinymist # Typst LSP
        marksman # Markdown LSP
        ltex-ls # grammar/spell checking LSP (LanguageTool)
        tex-fmt # LaTeX formatter
        tectonic # self-contained LaTeX engine
        vale # prose linter (style guide enforcement)
        typst # modern typesetting
        bibtool # manipulate BibTeX
      ];
    };
}
