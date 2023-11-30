{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.runCommand "vscode-0.0.0" {} "mkdir $out";
  };
}
