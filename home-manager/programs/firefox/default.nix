{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.runCommand "firefox-0.0.0" {} "mkdir $out";
  };
}
