{
  flake.modules.darwin.gui = {
    system.defaults = {
      menuExtraClock.Show24Hour = true;
      dock = {
        autohide = true;
        mineffect = "scale";
        minimize-to-application = true;
        show-process-indicators = false;
        show-recents = false;
        expose-animation-duration = 0.0;
        autohide-time-modifier = 0.0;
        autohide-delay = 0.0;
      };
      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
        ShowStatusBar = true;
        QuitMenuItem = true;
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = null;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
      };
    };
  };
}
