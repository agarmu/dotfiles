{ inputs, ... }:
{
  flake-file.inputs.apple-silicon = {
    url = "github:nix-community/nixos-apple-silicon";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.linux-desktop = {
    imports = [
      inputs.apple-silicon.nixosModules.default
    ]
    ++ [ ./_hardware-configuration.nix ];

    # TODO: figure out how to fix
    # ref: https://github.com/nix-community/nixos-apple-silicon/blob/main/docs/uefi-standalone.md#nixos-configuration
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false;

    # networking.hostName = "nixos"; # Define your hostname.

    # iwd > nmcli on asahi
    networking.wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };

    # Set your time zone.
    services.automatic-timezoned.enable = true;
    # time.timeZone = "Europe/Amsterdam";
    programs.xwayland.enable = true;
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    # i18n.defaultLocale = "en_US.UTF-8";
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    #   useXkbConfig = true; # use xkb.options in tty.
    # };
    #

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable sound.
    # services.pulseaudio.enable = true;
    # OR
    # services.pipewire = {
    #   enable = true;
    #   pulse.enable = true;
    # };
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };
    programs.firefox.enable = true;
    programs.zsh = {
      enable = true;
    };

    programs.niri.enable = true;
    services.seatd.enable = true;

  };
}
