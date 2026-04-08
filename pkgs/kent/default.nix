{
  python3Packages,
  writers,
}:
let
  ps = python3Packages;
in
writers.writePython3Bin "kent" {
  libraries = with ps; [
    requests
    rich
  ];
} (builtins.readFile ./main.py)
