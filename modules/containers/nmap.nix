_: {
  flake.modules.nixos.nmap-container =
    { pkgs, ... }:
    {
      containers.nmap-box = {
        autoStart = false; # only start manually
        ephemeral = true; # wipes state on stop, no leftovers

        privateNetwork = true;
        hostAddress = "10.0.0.1";
        localAddress = "10.0.0.2";

        config =
          { pkgs, ... }:
          {
            environment.systemPackages = with pkgs; [ nmap iputils bash python3 ];
            networking.nameservers = [ "1.1.1.1" ];
	    networking.useHostResolvConf = false;
            system.stateVersion = "26.05";
	    networking.firewall.enable = false;
          };
      };

      # NAT out through wlan0
      networking.nat = {
        enable = true;
        internalInterfaces = [ "ve-nmap-box" ];
        externalInterface = "wlan0";
      };
    };
}
