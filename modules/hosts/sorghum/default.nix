{
  inputs,
  ...
}:
let
  host = "sorghum";
in
{
  flake.modules.darwin.${host} = {
    imports = with inputs.self.modules.darwin; [
      base
      gui
      homebrew
      home-manager
    ];
    system.stateVersion = 6;
    networking.hostName = host;
    system.defaults.smb.NetBIOSName = host;

    home-manager.users.mukul = {
      imports = with inputs.self.modules.homeManager; [
        base
        dev
        gui
      ];
      home.stateVersion = "26.05";
    };
  };
  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" host;
}
