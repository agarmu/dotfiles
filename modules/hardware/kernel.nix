{ pkgs, ... }:
{
  flake.modules.nixos.asahi = {
    boot.kernelPatches = [
      /*
        TODO: {
        name = "fix-asahi-build";
        patch = pkgs.writeText "fix-asahi-build.diff" ''
          diff --git a/rust/kernel/iio/common/mod.rs b/rust/kernel/iio/common/mod.rs
          index 570644ce0938..b789e9bf44c9 100644
          --- a/rust/kernel/iio/common/mod.rs
          +++ b/rust/kernel/iio/common/mod.rs
          @@ -2,10 +2,5 @@

           //! IIO common modules

          -#[cfg(any(
          -    CONFIG_IIO_AOP_SENSOR_LAS = "y",
          -    CONFIG_IIO_AOP_SENSOR_ALS = "m",
          -    CONFIG_IIO_AOP_SENSOR_LAS = "y",
          -    CONFIG_IIO_AOP_SENSOR_ALS = "m",
          -))]
          +#[cfg(any(CONFIG_IIO_AOP_SENSOR_LAS, CONFIG_IIO_AOP_SENSOR_ALS,))]
           pub mod aop_sensors;
        '';
        }
      */
    ];
  };
}
