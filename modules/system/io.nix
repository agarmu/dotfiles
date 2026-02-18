_: {
  flake.modules.nixos.base = {
    # TODO
    services.libinput.enable = true;
    services.seatd.enable = true;
  };
  flake.modules.darwin.base = {
    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    system.defaults = {
      trackpad = {
        Clicking = true; # tap to click
        TrackpadRightClick = true; # enable two finger right click
        TrackpadThreeFingerDrag = false; # disable three finger drag
      };

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
      };
    };
  };
}
