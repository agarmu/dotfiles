{ lib, inputs, ... }:
let
  inherit (inputs.self) modules;
  stateVersion = "26.05";
  mkNixos =
    moduleName:
    let
      name = lib.removePrefix "host-" moduleName;
    in
    {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          modules.nixos.${moduleName}
          {
            networking.hostName = name;
            system.stateVersion = lib.mkDefault stateVersion;
          }
        ];
      };
    };
  mkDarwin =
    moduleName:
    let
      name = lib.removePrefix "host-" moduleName;
    in
    {
      ${name} = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          modules.darwin.${moduleName}
          {
            networking.hostName = lib.mkDefault name;
            system.stateVersion = lib.mkDefault 7;
          }
        ];
      };
    };
  makeConfigurations =
    mod: builder:
    (builtins.attrNames modules.${mod})
    |> (builtins.filter (lib.hasPrefix "host-"))
    |> map builder
    |> lib.mkMerge;
in
{
  flake.nixosConfigurations = makeConfigurations "nixos" mkNixos;
  flake.darwinConfigurations = makeConfigurations "darwin" mkDarwin;
}
