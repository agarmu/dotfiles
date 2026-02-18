{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.eza.enable = true;
      home.shellAliases =
        let
          exec = "${pkgs.eza}/bin/eza";
        in
        {
          ll = "${exec} -l --git";
          la = "${exec} -al --git";
          tree = "${exec} --tree";
          tral = "${exec} --tree -al";
        };
    };
}
