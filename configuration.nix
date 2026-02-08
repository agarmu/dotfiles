# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  apple-silicon,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./apple-silicon-support
  ];

  /*
    incredibly cursed. time to patch the kernel...
    ref: https://github.com/nix-community/nixos-apple-silicon/issues/422
  */

  boot.kernelPatches = [
    {
      name = "fix-asahi-build";
      patch = pkgs.writeText "fix-asahi-build.diff" ''
        diff --git a/rust/kernel/iio/common/mod.rs b/rust/kernel/iio/common/mod.rs
        index 570644ce0938..b789e9bf44c9 100644
        --- a/rust/kernel/iio/common/mod.rs
        +++ b/rust/kernel/iio/common/mod.rs
        @@ -2,10 +2,5 @@

         //! IIO common modules

        -#[cfg(any(
        -    CONFIG_IIO_AOP_SENSOR_LAS = "y",
        -    CONFIG_IIO_AOP_SENSOR_ALS = "m",
        -    CONFIG_IIO_AOP_SENSOR_LAS = "y",
        -    CONFIG_IIO_AOP_SENSOR_ALS = "m",
        -))]
        +#[cfg(any(CONFIG_IIO_AOP_SENSOR_LAS, CONFIG_IIO_AOP_SENSOR_ALS,))]
         pub mod aop_sensors;
      '';
    }
  ];



  # TODO: figure out how to fix
  # ref: https://github.com/nix-community/nixos-apple-silicon/blob/main/docs/uefi-standalone.md#nixos-configuration
  hardware.asahi.extractPeripheralFirmware = false;
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

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # setup nix

  nix = {
    settings = {
      # Enable flakes globally
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-experimental-features = [ "pipe-operators" ];
      # Set trusted users
      substituters = [
        "https://cache.nixos.org"
        "https://cachix.org/api/v1/cache/nix-community"
      ];

      trusted-substituters = [
        "https://cache.nixos.org"
        "https://cachix.org/api/v1/cache/nix-community"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      # optimize builds
      cores = 0;
      max-jobs = "auto";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mukul = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "seat"
      "video"
      "input"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      neovim
      zsh
    ];
  };

  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };
  programs.niri.enable = true;
  services.seatd.enable = true;
  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "greeter";
      command = ''
        ${pkgs.tuigreet}/bin/tuigreet --cmd niri
      '';
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.libinput.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    alejandra
    acpi
    kbd
    alacritty
    wl-clipboard
    xwayland
    nix-search
    wget
    rsync
    fuzzel # launcher - wayland
    brightnessctl
    mako
    swaylock
    zed-editor
    light
    bitwarden-desktop
    bitwarden-cli
    waybar
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # graphics.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
