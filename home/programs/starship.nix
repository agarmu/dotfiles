{pkgs, ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableTransience = true;
    settings = {
      add_newline = true;
      format = pkgs.lib.concatStrings [
        "[╭─](white) $time $username$hostname"
        "in $directory$package$git_branch$battery$cmd_duration"
        "\n"
        "[╰─](white)$character "
      ];
      scan_timeout = 10;
      username = {
        show_always = true;
        style_root = "bold red";
        style_user = "bold yellow";
        format = "[$user]($style)";
        disabled = false;
      };
      hostname = {
        ssh_only = false;
        format = "@[$hostname](bold blue)";
        trim_at = ".companyname.com";
        disabled = false;
      };
      directory = {
        read_only = "🔒";
        style = "bold cyan";
        read_only_style = "red";
        truncation_length = 2;
        truncation_symbol = "…/";
        format = "[$read_only]($read_only_style)[$path]($style) ";
        disabled = false;
      };
      git_branch = {
        symbol = "";
        truncation_length = 32;
        truncation_symbol = "";
      };
      battery = {
        disabled = false;
      };
      cmd_duration = {
        show_milliseconds = false;
        style = "bold yellow";
        format = "took [$duration]($style)";
      };
      character = {
        format = "$symbol";
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red) ";
        vicmd_symbol = "[❮](bold green)";
        disabled = false;
      };
      time = {
        disabled = false;
        time_format = "%R%z";
        style = "bold green";
        format = "[$time](bold green)";
      };
    };
  };
}
