{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        beads
        beads-viewer
      ];
    };

  flake.modules.darwin.base = {
    homebrew.casks = [
      "codex"
      "t3-code"
    ];
  };
}
