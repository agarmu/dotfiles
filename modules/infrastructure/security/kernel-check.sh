# Create a secure temporary file
tempfile=$(mktemp)

# Ensure the temporary file is deleted when the script exits
trap 'rm -f "$tempfile"' EXIT

# Use run0 to escalate privileges and dump sysctl to the temp file
# (Assuming run0 is available in the global system $PATH)
run0 sysctl -a > "$tempfile"

# Execute the kernel hardening checker
kernel-hardening-checker \
  -l /proc/cmdline \
  -c /proc/config.gz \
  -s "$tempfile"

