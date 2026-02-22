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
      programs.nixvim.plugins.lsp.servers.texlab.enable = true;
      programs.nixvim.plugins.lsp.servers.ltex.enable = true;
      programs.nixvim.plugins.lsp.servers.tinymist.enable = true;
      programs.zed-editor.extensions = [
        "latex"
        "typst"
      ];
      home.packages = with pkgs; [
        ltex-ls # grammar/spell checking LSP (LanguageTool)
        tex-fmt # LaTeX formatter
        tectonic # self-contained LaTeX engine
        vale # prose linter (style guide enforcement)
        typst # modern typesetting
      ];
    };
}
