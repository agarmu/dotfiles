_: {
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ acpi ];
      services.upower.enable = true;
    };

  flake.modules.nixos.mobile = _: {
    services.auto-cpufreq.enable = true;
  };
  flake.modules.homeManager.mobile =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.mukul.zpoweralertd ];
      systemd.user.services.zpoweralertd = {
        Unit = {
          Description = "UPower-powered power alerter; alternative to poweralertd";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.mukul.zpoweralertd} -V";
          Restart = "always";
        };
      };
    };
}
