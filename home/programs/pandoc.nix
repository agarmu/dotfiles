{
  pkgs,
  inputs,
  ...
}: {
  programs.pandoc = {
    enable = true;
  };
}
