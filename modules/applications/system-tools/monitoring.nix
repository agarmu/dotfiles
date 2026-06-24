{
  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    {
      programs.htop = {
        enable = true;
        settings = {
          color_scheme = 0;
          enable_mouse = 1;
          highlight_base_name = 1;
          highlight_megabytes = 1;
          highlight_threads = 1;
          hide_kernel_threads = 1;
          hide_userland_threads = 0;
          show_program_path = 0;
          show_cpu_usage = 1;
          show_cpu_frequency = 1;
          tree_view = 0;
          tree_view_always_by_pid = 0;
          sort_key = 46; # PERCENT_CPU
          sort_direction = -1;
          left_meters = [
            "AllCPUs2"
            "Blank"
            "Memory"
            "Swap"
          ];
          left_meter_modes = [
            1 # Bar
            2 # Text
            1 # Bar
            1 # Bar
          ];
          right_meters = [
            "Tasks"
            "LoadAverage"
            "Uptime"
            "Hostname"
          ];
          right_meter_modes = [
            2 # Text
            2 # Text
            2 # Text
            2 # Text
          ];
        };
      };

      programs.btop = {
        enable = true;
        settings = {
          truecolor = true;
          vim_keys = true;
          shown_boxes = "cpu mem net proc";
          update_ms = 2000;
          proc_sorting = "cpu lazy";
          proc_tree = false;
          proc_colors = true;
          proc_gradient = true;
          cpu_graph_upper = "total";
          cpu_graph_lower = "user";
          cpu_invert_lower = true;
          cpu_single_graph = false;
          mem_graphs = true;
          net_graphs = true;
          net_sync = true;
        };
      };

      programs.bottom.enable = true;
      home.shellAliases.top = "${pkgs.btop}/bin/btop";
      home.packages =
        with pkgs;
        [
          procs # better ps
          bandwhich # per-process network bandwidth
        ]
        ++ (lib.optionals pkgs.stdenv.isLinux [
          kmon
          psmisc
        ]);
    };
}
