{ ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableTransience = true;
    settings = {
      add_newline = true;
      scan_timeout = 10;
      username = {
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        disabled = false;
      };
      time = {
        disabled = false;
        time_format = "%R";
        style = "bold green";
        format = "[$time](bold green)";
      };
    };
  };
}
