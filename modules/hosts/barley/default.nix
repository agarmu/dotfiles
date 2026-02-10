{
  inputs,
  ...
}:
let
  host = "barley";
in
{
  flake.modules.darwin.${host} = {
    imports = with inputs.self.modules.darwin; [
      base
      gui
      homebrew
    ];
    system.stateVersion = 6;
    networking.hostName = host;
    system.defaults.smb.NetBIOSName = host;
  };
  flake.darwinConfigurations = inputs.self.lib.mkDarwin "aarch64-darwin" host;
}
