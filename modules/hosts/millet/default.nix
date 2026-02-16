{
  lib,
  inputs,
  ...
}:
{
  # we use disko... require it!
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  flake.modules.nixos.millet = {
    imports = with inputs.self.modules.nixos; [
      base
      home-manager
      ./_hardware-configuration.nix
      inputs.disko.nixosModules.disko
      ./_disk-config.nix
    ];
    boot.loader.efi = {
      canTouchEfiVariables = lib.mkForce true;
      efiSysMountPoint = "/boot";
    };
    system.stateVersion = "26.05";
    networking.hostName = "millet";
    home-manager.users.mukul = {
      imports = with inputs.self.modules.homeManager; [
        base
      ];
      home.stateVersion = "26.05";
    };

    # specific config... refactor into server module or something...
    services.openssh = {
      enable = true;
      settings = {
        # PermitRootLogin = "no";
        # PasswordAuthentication = false;
      };
    };

    # Disable autologin.
    services.getty.autologinUser = null;
    documentation.enable = false;
    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
  flake.nixosConfigurations = inputs.self.lib.mkNixos "aarch64-linux" "millet";
}
