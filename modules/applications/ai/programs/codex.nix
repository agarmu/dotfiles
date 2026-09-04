_: {
  #flake.modules.homeManager.ai = {
  #  # programs.codex.enable = true;
  #  # programs.codex.package = pkgs.codex.overrideAttrs (
  #  #   old:
  #  #   lib.optionalAttrs (lib.versionOlder old.version "0.153.3") {
  #  #     version = "0.153.3";
  #  #   }
  #  # );
  #};
  flake.modules.darwin.homebrew = {
    homebrew.casks = [ "codex" ];
  };
}
