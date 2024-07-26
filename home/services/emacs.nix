{
  config,
  pkgs,
  inputs,
  ...
}: let
in {
  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
  };
}
