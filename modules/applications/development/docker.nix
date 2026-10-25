{
  flake.modules.darwin.homebrew.homebrew.casks = [ "docker-desktop" ];

  flake.modules.nixos.host-wheat = {
    virtualisation.docker.enable = true;
    users.users.mukul.extraGroups = [ "docker" ];
  };

  flake.modules.homeManager.dev =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        docker-client
        docker-compose
        docker-buildx
        devcontainer
        dockerfile-language-server
      ];
      programs.zed-editor.extensions = [ "dockerfile" ];
      programs.nixvim.plugins = {
        treesitter.grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          dockerfile
        ];
        lsp.servers.dockerls.enable = true;
      };
    };
}
