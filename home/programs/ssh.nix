{pkgs, ...}: let
  purdueUsername = "agarw396";
  purdueCSSystem = sn: {
    name = "${sn}";
    value =
      {
        hostname = "${sn}.cs.purdue.edu";
        user = purdueUsername;
        forwardAgent = true;
        proxyJump = "${purdueUsername}@data.cs.purdue.edu";
      };
  };
  ServerMC = builtins.map (x: "mc${builtins.toString x}") (pkgs.lib.lists.range 17 21);
  ServerBORGA = builtins.map (x: "borg0${builtins.toString x}") (pkgs.lib.lists.range 1 9);
  ServerBORGB = builtins.map (x: "borg${builtins.toString x}") (pkgs.lib.lists.range 10 24);
  serverNames = ServerMC ++ ServerBORGA ++ ServerBORGB;
  servers = builtins.listToAttrs (builtins.map purdueCSSystem serverNames);
in {
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
      "data" = {
        hostname = "data.cs.purdue.edu";
        user = "agarw396";
        forwardAgent = true;
      };
    } // servers;
  };
}
