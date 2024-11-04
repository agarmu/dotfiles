{inputs, ...}: let
  username = "mukul";
  programs = map (n: "${./programs}/${n}") (builtins.attrNames (builtins.readDir ./programs));
  services = map (n: "${./services}/${n}") (builtins.attrNames (builtins.readDir ./services));
in {
  # import sub modules
  imports = [./packages.nix] ++ programs; #++ services;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    shellAliases = {
      gpl = "git pull";
      gp = "git push";
      lg = "lazygit";
      gc = "git commit -v";
      kb = "git commit -m \"\$(curl -s https://whatthecommit.com/index.txt)\"";
      gsv = "git status -v";
      gfc = "git fetch && git checkout";
      gl = "git log --graph";
      ll = "eza -l --git";
      la = "eza -al --git";
      vi = "nvim";
      vim = "nvim";
      tree = "eza --tree";
      tral = "eza --tree -al";
      cat = "bat";
      nv = "neovide";
      ping = "gping";
      diff = "delta";
      top = "btop";
      cl = "clear";
      cls = "clear";
      kitten = "kitty +kitten";
      s = "kitten ssh";
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
