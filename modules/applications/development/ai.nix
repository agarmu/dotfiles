{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.beads ];
    };

  flake.modules.darwin.base = {
    homebrew.casks = [
      "codex"
      "t3-code"
    ];
  };
}
