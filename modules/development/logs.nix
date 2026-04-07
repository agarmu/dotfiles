_: {
  flake.modules.homeManager.base =
    { pkgs, ... }:
    let
      mkSysApp =
        name: scope:
        pkgs.writeShellApplication {
          inherit name;
          runtimeInputs = with pkgs; [
            systemctl-tui
            lnav
          ];
          runtimeEnv = {
            SYSTEMD_PAGERSECURE = "1";
            PAGER = "lnav";
          };
          text = "systemctl-tui -s ${scope}";
        };
    in
    {
      home.packages = with pkgs; [
        systemctl-tui
        lnav
        (mkSysApp "sys" "all")
        (mkSysApp "sysv" "global")
        (mkSysApp "sysu" "user")
      ];
    };
}
