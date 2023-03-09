{ config, lib, pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = [
           /*  # General
            pkgs.vscode-extensions.alefragnani.bookmarks
            pkgs.vscode-extensions.draivin.hscopes
            pkgs.vscode-extensions.draivin.hsnips
            pkgs.vscode-extensions.vscodevim.vim
            # Themes
            pkgs.vscode-extensions.dracula-theme.theme-draula
            ### Languages
            # C/C++
            pkgs.vscode-extensions.ms-vscode.cpptools-extension-pack
            # Haskell
            pkgs.vscode-extensions.justusadam.language-haskell
            # Jupyter
            pkgs.vscode-extensions.ms-python.python
            # LaTeX
            pkgs.vscode-extensions.mathematic.vscode-latex
            pkgs.vscode-extensions.tecosaur.latex-utilities
            pkgs.vscode-extensions.james-yu.latex-workshop
            pkgs.vscode-extensions.bnavetta.zoterolatex
            # Nix
            pkgs.vscode-extensions.bbenoist.nix
            # Python
            pkgs.vscode-extensions.ms-python.python
            pkgs.vscode-extensions.ms-python.vscode-pylance
            pkgs.vscode-extensions.ms-python.isort
            # Rust
            pkgs.vscode-extensions.rust-lang.rust-analyzer */

        ];
        userSettings = {
    "telemetry.telemetryLevel"= "off";
    "latex-workshop.latex.tools"= [
        {
            "name"= "latexmk";
            "command"= "latexmk";
            "args"= [
                "-xelatex"
                "-synctex=1"
                "-interaction=nonstopmode"
                "-file-line-error"
                "%DOC%"
            ];
        }
    ];
    "latex-workshop.view.pdf.viewer"= "external";
    "latex-workshop.view.pdf.external.viewer.command"= "zathura";
    "latex-workshop.view.pdf.external.viewer.args"= [
        "--synctex-editor-command"
        "code -r -g \"%{input}:%{line}\""
        "%PDF%"
    ];
    "latex-workshop.view.pdf.external.synctex.command"= "zathura";
    "latex-workshop.view.pdf.external.synctex.args"= [
        "--synctex-forward=%LINE%:0:%TEX%"
        "%PDF%"
    ];
    "latex-workshop.latex.autoBuild.run"= "onSave";
    "workbench.colorTheme"= "One Monokai";
    "cSpell.diagnosticLevel"= "Warning";
    "command-runner.terminal.name"= "runCommand";
    "command-runner.terminal.autoClear"= true;
    "command-runner.terminal.autoFocus"= false;
    "command-runner.commands"= {
        "inkscapeCreate"= "inkscape-figures create \${selectedText} \${workspaceFolder}/figures";
        "inkscapeEdit"= "inkscape-figures edit \${workspaceFolder}/figures";
        "inkscapeStart"= "inkscape-figures watch";
        "quiver"= "open -na 'Google Chrome' --args --new-window <path-to-quiver>/quiver/src/index.html";
    };
    "editor.fontFamily"= "'JetBrainsMono Nerd Font Mono', Menlo; Monaco; 'Courier New', 'SF Pro', monospace";
    "latex-workshop.bibtex-format.sortby"= [
        "author"
        "title"
    ];
    "cSpell.userWords"= [
        "linearization"
        "Scatterplot"
    ];
    "[latex]"= {
        "editor.defaultFormatter"= "mathematic.vscode-latex";
    };
    "latex-workshop.intellisense.citation.backend"= "biblatex";
    "latex-utilities.zotero.citeMethod"= "vscode";
    "editor.wordWrapColumn"= 40;
    "latex-workshop.linting.chktex.convertOutput.column.chktexrcTabSize"= 4;
    "files.associations"= {
        "*.rmd"= "markdown";
    };
    "jupyter.widgetScriptSources"= [
        "jsdelivr.com"
        "unpkg.com"
    ];
    "[python]"= {
        "editor.defaultFormatter"= "ms-python.python";
    };
    "terminal.integrated.commandsToSkipShell"= [
        "language-julia.interrupt"
    ];
    "julia.symbolCacheDownload"= true;
    "editor.minimap.renderCharacters"= false;
    "editor.minimap.enabled"= false;
        };
    };
}