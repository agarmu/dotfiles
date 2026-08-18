{
  makeSetupHook,
  stdenv,
}:
makeSetupHook {
  name = "install-rust-cdylib-hook";
  substitutions = {
    cargoShortTarget = stdenv.hostPlatform.rust.cargoShortTarget;
    sharedLibrarySuffix = stdenv.hostPlatform.extensions.sharedLibrary;
  };
} ./install-rust-cdylib-hook.sh
