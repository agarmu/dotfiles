{ pkgs, ... }:
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.texlive = {
        enabe = true;
        package = pkgs.texliveFull;
      };
      home.packages = with pkgs; [
        texlab
        tex-fmt
        typst
        tinymist
      ];
    };
}
