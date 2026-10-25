{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.vscodium = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = true;
        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
          extensions = with pkgs.vscode-extensions; [
            myriad-dreamin.tinymist
            james-yu.latex-workshop
            redhat.vscode-yaml
            vscodevim.vim
            ms-python.python
            ms-python.debugpy
            detachhead.basedpyright
            charliermarsh.ruff
            dbaeumer.vscode-eslint
            esbenp.prettier-vscode
            ms-azuretools.vscode-docker
          ];
          userSettings = {
            "python.languageServer" = "None";
            "python.defaultInterpreterPath" = "\${workspaceFolder}/.venv/bin/python";
            "[python]"."editor.defaultFormatter" = "charliermarsh.ruff";
            "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[javascriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[typescript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[typescriptreact]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
            "[typst]"."editor.defaultFormatter" = "myriad-dreamin.tinymist";
            "tinymist.serverPath" = "${pkgs.tinymist}/bin/tinymist";
          };
        };
      };
    };
}
