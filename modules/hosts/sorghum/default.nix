{
  inputs,
  ...
}:
{
  flake.modules.darwin.host-sorghum = {
    imports = with inputs.self.modules.darwin; [
      base
      gui
      homebrew
      home-manager
    ];
    system.stateVersion = 6;
    home-manager.users.mukul = {
      imports = with inputs.self.modules.homeManager; [
        base
        dev
        gui
        mobile
      ];
      home.stateVersion = "26.05";
    };
  };
}
