{
  flake.modules.homeManager.linuxGui = {
    programs.waybar.style = ''
      * {
        font-family: "Nordwand Mono";
        font-size: 14px;
      }
      ${builtins.readFile ./bar.css}
    '';
  };
}
