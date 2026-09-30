{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.vscodium = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = false;
        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
          extensions = with pkgs.vscode-extensions; [
            myriad-dreamin.tinymist
            james-yu.latex-workshop
            redhat.vscode-yaml
            vscodevim.vim
          ];
          userSettings = {
            "[typst]"."editor.defaultFormatter" = "myriad-dreamin.tinymist";
            "tinymist.serverPath" = "${pkgs.tinymist}/bin/tinymist";
          };
        };
      };
    };
}
