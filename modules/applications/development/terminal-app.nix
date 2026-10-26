{
  flake.modules.darwin.gui =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      profileName = "catppuccin-mocha";
      terminalTheme = pkgs.catppuccin-terminal.override {
        font = "${pkgs.nordwand-mono}/share/fonts/truetype/NordwandMono-Regular.ttf";
        fontSize = 12;
      };
      user = lib.escapeShellArg config.system.primaryUser;
    in
    {
      system.defaults.CustomUserPreferences."com.apple.Terminal" = {
        "Default Window Settings" = profileName;
        "Startup Window Settings" = profileName;
      };

      system.activationScripts.postActivation.text = ''
        /bin/launchctl asuser "$(/usr/bin/id -u -- ${user})" \
          /usr/bin/sudo --user=${user} -- \
          /usr/bin/defaults write com.apple.Terminal 'Window Settings' \
          -dict-add ${lib.escapeShellArg profileName} "$(/bin/cat ${terminalTheme}/share/terminal/catppuccin-mocha.terminal)"
      '';
    };
}
