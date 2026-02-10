{
  self,
  lib,
  ...
}:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "mukul" true)
    {
      nixos.mukul = {
        imports = with self.modules.nixos; [
          # developmentEnvironment
        ];
        users.users.mukul = {
          isNormalUser = true;
          extraGroups = [
            "audio"
            "seat"
            "video"
          ];
        };
      };

      darwin.mukul = {
        imports = with self.modules.darwin; [
          # drawingApps
          # developmentEnvironment
        ];
      };

      homeManager.mukul =
        { pkgs, ... }:
        {
          imports = with self.modules.homeManager; [
            system-desktop
            # adminTools
            # vscode
            # passwordManager
          ];
          home.packages = with pkgs; [
            mediainfo
          ];
        };
    }
  ];
}
