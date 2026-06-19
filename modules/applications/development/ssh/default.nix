{
  flake.modules.nixos.server = {
    programs.mosh.enable = true;
  };
  flake.modules.nixos.base = {
    programs.ssh.setXAuthLocation = false;
  };
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      services.ssh-agent.enable = true;
      home.packages = with pkgs; [ mosh ];
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*" = {
          # safety
          forwardAgent = false;
          addKeysToAgent = "no";
          hashKnownHosts = true;
          # speed/latency
          compression = true;
          serverAliveInterval = 0;
          serverAliveCountMax = 5;
          # other config
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
      };
    };
}
