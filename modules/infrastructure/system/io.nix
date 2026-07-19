{
  flake.modules.nixos.base = {
    services.libinput.enable = true;
  };
  flake.modules.darwin.base = {
    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    system.defaults = {
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = false;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true;
        "com.apple.sound.beep.feedback" = 0;

        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = true;

        InitialKeyRepeat = 15;
        KeyRepeat = 3;

        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
    };
  };
}
