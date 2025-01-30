{...}: {
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
      "borg01" = {
        hostname = "borg01.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg02" = {
        hostname = "borg02.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg03" = {
        hostname = "borg03.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg04" = {
        hostname = "borg04.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg05" = {
        hostname = "borg05.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg06" = {
        hostname = "borg06.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg07" = {
        hostname = "borg07.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg08" = {
        hostname = "borg08.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg09" = {
        hostname = "borg09.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg10" = {
        hostname = "borg10.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg11" = {
        hostname = "borg11.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg12" = {
        hostname = "borg12.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg13" = {
        hostname = "borg13.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg14" = {
        hostname = "borg14.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg15" = {
        hostname = "borg15.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg16" = {
        hostname = "borg16.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg17" = {
        hostname = "borg17.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg18" = {
        hostname = "borg18.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg19" = {
        hostname = "borg19.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg20" = {
        hostname = "borg20.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg21" = {
        hostname = "borg21.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg22" = {
        hostname = "borg22.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg23" = {
        hostname = "borg23.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
      "borg24" = {
        hostname = "borg24.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
    };
  };
}
