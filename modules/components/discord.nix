_: {
  flake.modules.homeManager.nixosGui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vesktop
      ];
    };
}
