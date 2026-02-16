{ lib, ... }:
let
  pad = k: s: if (builtins.stringLength s) >= k then s else "0${pad (k - 1) s}";
  padn = k: n: pad k (builtins.toString n);
  purdueUsername = "agarw396";
  purdueCSSystem = sn: {
    name = "${sn}";
    value = {
      hostname = "${sn}.cs.purdue.edu";
      user = purdueUsername;
      forwardAgent = true;
      proxyJump = "data";
    };
  };
  serverrange =
    pfx: lb: ub:
    builtins.map (x: "${pfx}${padn 2 x}") (lib.lists.range lb ub);
  serverNames = (serverrange "mc" 18 21) ++ (serverrange "borg" 1 24) ++ (serverrange "xinu" 1 21);
  servers = builtins.listToAttrs (builtins.map purdueCSSystem serverNames) // {
    "cs426" = {
      hostname = "localhost";
      user = "cs426";
      port = 4235;
      proxyJump = "mc20";
    };
    "vulcan" = {
      hostname = "vulcan.moe";
      user = "mukul";
      port = 4225;
    };
    "millet" = {
      hostname = "millet.agarmu.com";
      user = "mukul";
      forwardAgent = true;
    };
    "gh-test" = {
      hostname = "github.com";
      user = "git";
    };
    "scholar" = {
      hostname = "scholar.rcac.purdue.edu";
      user = "agarw396";
      forwardAgent = true;
      proxyJump = "data";
    };
    "data" = {
      hostname = "data.cs.purdue.edu";
      user = "agarw396";
      forwardAgent = true;
    };
  };
in
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {

    };
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
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
        }
        // servers;
      };
    };
}
