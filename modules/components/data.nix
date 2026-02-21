_: {
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        miller # CSV/JSON/tabular data processor
        fx # interactive JSON viewer
        dasel # query JSON/YAML/TOML/XML
      ];
    };
}
