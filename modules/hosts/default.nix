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
  makeConfigurations =
    mod: builder:
    (builtins.attrNames modules.${mod})
    |> (builtins.filter (lib.hasPrefix "host-"))
    |> map builder
    |> lib.mkMerge;
in
{
  flake.nixosConfigurations = makeConfigurations "nixos" mkNixos;
}
