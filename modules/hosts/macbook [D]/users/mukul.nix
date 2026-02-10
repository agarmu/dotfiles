{
  inputs,
  ...
}:
{
  flake.modules.darwin.macbook = {
    imports = with inputs.self.modules.darwin; [
      mukul
    ];

    home-manager.users.mukul = {
      ###
    };
  };
}
