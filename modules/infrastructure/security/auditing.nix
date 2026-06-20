{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    let
      kernel-check = pkgs.writeShellApplication {
        name = "kernelcheck";
        # This populates the $PATH inside the script so you can call them normally
        runtimeInputs = with pkgs; [
          coreutils
          procps
          kernel-hardening-checker
          systemd
        ];
        text = builtins.readFile ./kernel-check.sh;
      };
    in
    {
      environment.systemPackages = [
        kernel-check
      ]
      ++ (with pkgs; [
        kernel-hardening-checker
        lynis
        clamav
        aide
      ]);
      boot.kernelParams = [ "audit=1" ];
      security.auditd.enable = true;
      security.audit.enable = true;
      security.audit.rules = [
        # Log all program executions on 64-bit architecture
        "-a exit,always -F arch=b64 -S execve"
      ];
    };
}
