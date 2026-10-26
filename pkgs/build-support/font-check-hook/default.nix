{
  makeSetupHook,
  opentype-sanitizer,
}:

makeSetupHook {
  name = "font-check-hook";
  propagatedBuildInputs = [
    opentype-sanitizer
  ];
} ./font-check-hook.sh
