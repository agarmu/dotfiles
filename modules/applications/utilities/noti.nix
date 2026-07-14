{
  flake.modules.homeManager.base = { pkgs, ... }: {
    programs.noti = {
      enable = true;
      # TODO:  go back when github.com/nixos/nixpkgs/pull/541626 is merged
      package = pkgs.stable.noti;
    };
  };
}
