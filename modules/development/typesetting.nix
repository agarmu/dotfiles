_: {
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.texlive = {
        enable = true;
        extraPackages = t: {
          inherit (t)
            scheme-medium
            latexmk
            collection-bibtexextra
            collection-latexextra
            ;
        };
      };
      home.packages = with pkgs; [
        texlab
        tex-fmt
        typst
        tinymist
      ];
    };
}
