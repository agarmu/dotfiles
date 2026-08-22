{
  flake.modules.homeManager.ai = {
    programs.herdr = {
      enable = true;
      settings = {
        onboarding = false;
        terminal = {
          shell_mode = "auto";
          new_cwd = "follow";
        };
        theme = {
          name = "catppuccin";
          auto_switch = true;
          light_name = "catppuccin-latte";
          dark_name = "catppuccin";
        };
        update = {
          version_check = false;
          manifest_check = false;
        };
        ui = {
          agent_panel_sort = "priority";
          toast = {
            delivery = "herdr";
            delay_seconds = 1;
          };
          sound.enabled = true;
        };
        session.resume_agents_on_restore = true;
        remote.manage_ssh_config = true;
        keys.prefix = "ctrl+b";
      };
    };
  };
}
