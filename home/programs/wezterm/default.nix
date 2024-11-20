{
  pkgs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    package = pkgs.runCommand "wezterm-0.0.0" {} "mkdir $out";
    extraConfig = builtins.readFile ./wezterm.lua; 
  };
}
