_: {
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
        texlab
        tex-fmt
        typst
        tinymist
      ];
    };
}
