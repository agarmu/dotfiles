let
  genericPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        git
        tmux
        nano
      ];
    };
in
{
  flake.modules.nixos.base = {
    imports = [
      genericPackages
    ];
  };

  flake.modules.darwin.base = {
    imports = [
      genericPackages
    ];
  };
}
