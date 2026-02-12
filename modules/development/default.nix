{ lib, inputs, ... }:
{
  flake.modules.homeManager.darwinDev = { };
  flake.modules.homeManager.nixosDev = { };
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    with inputs.self.modules.homeManager;
    {
      imports =
        (lib.optionals pkgs.stdenv.isLinux [ nixosDev ])
        ++ (lib.optionals pkgs.stdenv.isDarwin [ darwinDev ]);
    };
}
