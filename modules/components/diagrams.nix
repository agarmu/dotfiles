_: {
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        graphviz # graph/dot visualization
        d2 # diagram scripting language
      ];
    };
}
