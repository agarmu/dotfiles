# flake-parts configuration
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
