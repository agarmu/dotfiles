{pkgs, ...}: {
  system = {
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock
      dock = {
        autohide = false;
        show-recents = false; # disable recent apps
      };

      # customize finder
      finder = {
        _FXShowPosixPathInTitle = true; # show full path in finder title
        AppleShowAllExtensions = true; # show all file extensions
        FXEnableExtensionChangeWarning = true; # enable when changing file extension
        QuitMenuItem = true; # enable quit menu item
        ShowPathbar = true; # show path bar
        ShowStatusBar = true; # show status bar
      };

      # customize trackpad
      trackpad = {
        Clicking = true; # tap to click
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = false; # disable three finger drag
      };

      # customize macOS
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true; # enable natural scrolling(default to true)
        "com.apple.sound.beep.feedback" = 0; # disable beep sound when pressing volume up/down key

        AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
        ApplePressAndHoldEnabled = true; # enable press and hold

        InitialKeyRepeat = 15; # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
        KeyRepeat = 3; # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)

        NSAutomaticCapitalizationEnabled = false; # disable auto capitalization
        NSAutomaticDashSubstitutionEnabled = false; # enable auto dash substitution
        NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution
        NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution
        NSAutomaticSpellingCorrectionEnabled = false; # disable auto spelling correction
        NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
    };
    stateVersion = 5;
  };

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;
  # TODO: add certs to blacklist
  security.pki.caCertificateBlacklist = [];
  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableFzfGit = true;
    enableSyntaxHighlighting = true;
  };
  environment.shells = [
    pkgs.zsh
  ];
  environment.shellInit = ''
    eval "$(/usr/libexec/path_helper)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';

  fonts.packages = with pkgs; [
    lato
    liberation_ttf
    libre-baskerville
    montserrat
    font-awesome
    noto-fonts
    noto-fonts-emoji
    libertinus
    iosevka
    eb-garamond
    cascadia-code
    (
      nerdfonts.override
      {
        fonts = [
          "FiraCode"
        ];
      }
    )
  ];
}
