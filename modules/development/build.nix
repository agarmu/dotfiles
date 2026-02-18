_: {
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cmake # Very bad but must use
        gnumake # Often used badly
        just # More sane makefile
        meson # build tool
      ];
    };
}
