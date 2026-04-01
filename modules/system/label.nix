{ inputs, ... }:
let
  inherit (inputs) self;
  rev = self.rev or (self.dirtyRev or null);
in
{
  flake.modules.nixos.base = {
    system.configurationRevision = rev;
  };
}
