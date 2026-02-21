_: {
  flake.modules.nixos.base = _: {
    services.kanata = {
      enable = true;
      keyboards.default = {
        config = ''
          (defsrc
            caps
          )
          (deflayer default
            (tap-hold 200 200 esc lctl)
          )
        '';
      };
    };
  };
}
