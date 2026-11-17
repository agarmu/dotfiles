{
  # Useful for jj development
  flake.modules.darwin.base = {
    # tmpfs RAM disk at /Volumes/RAMDisk
    # mounted at boot time
    launchd.daemons.ramdisk = {
      script = ''
        mnt=/Volumes/RAMDisk
        /bin/mkdir -p "$mnt"
        if ! /sbin/mount | /usr/bin/grep -q " on $mnt "; then
          # -e          : case-sensitive
          # -o nobrowse : hide from Finder sidebar/Desktop
          /sbin/mount_tmpfs -e -o nobrowse "$mnt"
        fi
        /bin/chmod a+wx "$mnt"
      '';
      serviceConfig = {
        RunAtLoad = true;
        StandardOutPath = "/var/log/ramdisk.log";
        StandardErrorPath = "/var/log/ramdisk.log";
      };
    };
  };
}
