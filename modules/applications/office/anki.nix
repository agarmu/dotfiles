{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      programs.anki = {
        enable = true;
        addons = with pkgs.ankiAddons; [
          review-heatmap # keep track of activity
          puppy-reinforcement # cute animals for support
          image-occlusion-enhanced
        ];
      };
    };
}
