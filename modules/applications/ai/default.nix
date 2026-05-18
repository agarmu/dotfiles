{ inputs, ... }:
{
  flake.modules.homeManager.gui.imports = [
    inputs.self.modules.homeManager.ai
  ];
}
