{
  inputs,
  ...
}:
{
  flake.modules.darwin.host-sorghum = {
    imports = with inputs.self.modules.darwin; [
      base
      gui
      home-manager
    ];
    home-manager.users.mukul = {
      imports = with inputs.self.modules.homeManager; [
        base
        dev
        gui
        darwin
        image
      ];
      home.stateVersion = "26.05";
    };
  };
}
