{
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    compression = true;
    hashKnownHosts = true;
    serverAliveCountMax = 5;
    matchBlocks = {
      "gh-test" = {
        hostname = "github.com";
        user = "git";
      };
      "mc17" = {
        hostname = "mc17.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "mc18" = {
        hostname = "mc18.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "mc19" = {
        hostname = "mc19.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };

      "mc20" = {
        hostname = "mc20.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "mc21" = {
        hostname = "mc21.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "data" = {
        hostname = "data.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "anvil" = {
        hostname = "anvil.rcac.purdue.edu";
        user = "x-magarwal";
        forwardAgent = true;
      };
      "oracle" = {
        hostname = "207.211.183.164";
        user = "mukul";
        forwardAgent = true;
      };
    };
  };
}
