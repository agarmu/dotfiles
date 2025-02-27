{pkgs, ...}: {
  programs.wezterm = {
    package = pkgs.runCommand "firefox-0.0.0" {} "mkdir $out";
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
