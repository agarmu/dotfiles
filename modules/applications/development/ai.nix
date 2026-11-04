{ inputs, ... }:
{
  flake-file.inputs.agent-skills = {
    url = "github:Kyure-A/agent-skills-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake-file.inputs.mattpocock-skills = {
    url = "github:mattpocock/skills";
    flake = false;
  };

  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      imports = [ inputs.agent-skills.homeManagerModules.default ];

      programs.agent-skills = {
        enable = true;
        sources.mattpocock = {
          path = inputs.mattpocock-skills;
          subdir = "skills";
        };
        skills.enableAll = [ "mattpocock" ];
        targets.agents.enable = true;
      };

      home.packages = with pkgs; [
        beads
        beads-viewer
        herdr
        herdr-gpui
      ];
    };

  flake.modules.darwin.base = {
    homebrew.casks = [
      "codex"
      "t3-code"
    ];
  };
}
