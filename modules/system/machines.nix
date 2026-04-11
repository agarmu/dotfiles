_: {
  flake.modules.nixos.base =
    { lib, config, ... }:
    let
      machineSubmodule = lib.types.submodule {
        options = {
          number = lib.mkOption {
            type = lib.types.ints.between 1 255;
            description = "Unique machine number (1–255).";
          };
          description = lib.mkOption {
            type = lib.types.str;
            description = "Human-readable description of this device.";
          };
        };
      };
    in
    {
      options = {
        machines = lib.mkOption {
          type = lib.types.attrsOf machineSubmodule;
          description = "Registry of all machines in the fleet.";
        };
        machine = lib.mkOption {
          type = machineSubmodule;
          description = "This machine's identity.";
        };
      };

      config.assertions =
        let
          numbers = lib.mapAttrsToList (name: m: {
            inherit name;
            inherit (m) number;
          }) config.machines;
          duplicates = lib.filter (a: lib.any (b: a.name != b.name && a.number == b.number) numbers) numbers;
        in
        [
          {
            assertion = duplicates == [ ];
            message =
              "Duplicate machine numbers: "
              + lib.concatMapStringsSep ", " (m: "${m.name}=${toString m.number}") duplicates;
          }
        ];

      config.machine = config.machines.${config.networking.hostName};

      config.machines = {
        wheat = {
          number = 1;
          description = "Apple MacBook Pro (M1 Pro) running Asahi Linux";
        };
        millet = {
          number = 2;
          description = "Oracle Cloud VPS (Ampere A1)";
        };
      };
    };
}
