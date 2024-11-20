{
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
      "ee1" = {
        hostname = "ee220clnx1.ecn.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "ee3" = {
        hostname = "ee220clnx3.ecn.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "ee4" = {
        hostname = "ee230lnx04.ecn.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
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
    };
  };
}
