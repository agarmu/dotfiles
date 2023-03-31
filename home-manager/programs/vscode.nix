{ config, lib, pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
            # General
            # vscodevim.vim
            # Themes
            dracula-theme.theme-dracula
            ### Languages
            # LaTeX
            james-yu.latex-workshop
            # Nix
            bbenoist.nix
            # Rust
            rust-lang.rust-analyzer
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
                name = "hscopes";
                publisher = "draivin";
                version = "0.0.9";
                sha256 = "RgZxnAysKiHAdUQQuOL7TP0SWTBCsk7V28zy5NXBJa0=";
            }
            {
                name = "hsnips";
                publisher = "draivin";
                version = "0.2.8";
                sha256 = "hLz+BkOzAzatpCNuVndZlvKgThULGdwUl1x8V7h1tK4=";
            }
            {
                name = "cpptools";
                publisher = "ms-vscode";
                version = "1.14.4";
                sha256 = "3gWMrsVr5XjsuXL3DJ+KkVVD2RWtN6Uqdp3e7u9OwnM=";
            }
            {
                name = "python";
                publisher = "ms-python";
                version = "2023.5.10721010";
                sha256 = "m1ft4CAOkUvG23JBPRNL1P+RhkXRGCAwFrQ36l2FWKk=";
            }
            {
                name = "vscode-latex";
                publisher = "mathematic";
                version = "1.2.0";
                sha256 = "8QTza0aK3Qu0UhBwpW8b90EztoJJxDrVrGDHqWDZsJE=";
            }
            {
                name = "latex-utilities";
                publisher = "tecosaur";
                version = "0.4.10";
                sha256 = "tNf4sTsae+NKB7QZ5PQOXI6T14eEH0YIK/LhgWq6QHA=";
            }
            {
                name = "zoterolatex";
                publisher = "bnavetta";
                version = "0.4.1";
                sha256 = "PLenGF6A68LodZfGtjk8LxdrWb/yd2cMtp0VTEwwxWQ=";
            }
            {
                name = "vscode-pylance";
                publisher = "ms-python";
                version = "2023.3.11";
                sha256 = "aGnBNASxqA4pA9900DItMjkTiLQtZdiS/YnJ7yXE0bI=";
            }
            {
                name = "isort";
                publisher = "ms-python";
                version = "2022.8.0";
                sha256 = "l7mXTKdAE56DdnSaY1cs7sajhG6Yzz0XlZLtHY2saB0=";
            }
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
    "editor.fontFamily"= "Menlo";
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
