{
  flake.modules.darwin.base = {
    nixpkgs.overlays = [
      # workaround for https://github.com/nixos/nixpkgs/issues/548457
      (final: prev: {
        libgphoto2 = prev.libgphoto2.overrideAttrs (oldAttrs: {
          buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ final.gettext ];

        });
      })
    ];
  };
}
