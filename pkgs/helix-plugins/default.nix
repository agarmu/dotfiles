{
  build-support,
  lib,
  newScope,
}:
lib.makeScope newScope (self: {
  inherit (build-support) buildHelixPlugin installRustCdylibHook;
  glyph = self.callPackage ./glyph.nix { };
  notify = self.callPackage ./notify.nix { };
  forest = self.callPackage ./forest.nix { };
  oil = self.callPackage ./oil.nix { };
  scooter = self.callPackage ./scooter.nix { };
  smooth-scroll = self.callPackage ./smooth-scroll.nix { };
  streal = self.callPackage ./streal.nix { };
  wakatime = self.callPackage ./wakatime.nix { };
  file-watcher = self.callPackage ./file-watcher.nix { };
})
