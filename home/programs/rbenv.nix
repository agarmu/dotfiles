{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.rbenv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    plugins = [
      {
        name = "ruby-build";
        src = inputs.ruby-build;
      }
    ];
  };
}
