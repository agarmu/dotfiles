{lib, ...}: let
  name = "Rosencrantz";
in {
  networking.computerName = name;
  networking.hostName = lib.strings.toLower name;
  networking.localHostName = lib.strings.toLower name;
}
