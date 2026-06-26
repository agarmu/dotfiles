{
  flake.modules.darwin.base = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.mukul.omniwm ];
  };
}
