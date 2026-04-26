{ iosevka, symlinkJoin }:
let
  baseBuildPlan = builtins.readFile ./build-plan.toml;

  patchBuildPlan =
    {
      set,
      sourcePlan,
      sourceFamily,
      family,
    }:
    builtins.replaceStrings
      [
        "[buildPlans.${sourcePlan}]"
        "[buildPlans.${sourcePlan}."
        "family = \"${sourceFamily}\""
      ]
      [
        "[buildPlans.Iosevka${set}]"
        "[buildPlans.Iosevka${set}."
        "family = \"${family}\""
      ]
      baseBuildPlan;

  mkSet =
    {
      set,
      sourcePlan,
      sourceFamily,
      family,
    }:
    iosevka.override {
      set = "${set}";
      privateBuildPlan = patchBuildPlan {
        inherit
          set
          sourcePlan
          sourceFamily
          family
          ;
      };
    };

  sans = mkSet {
    set = "Kian";
    sourcePlan = "iosevka";
    sourceFamily = "Iosevka";
    family = "Iosevka Kian";
  };

  term = mkSet {
    set = "KianTerm";
    sourcePlan = "iosevka-term";
    sourceFamily = "Iosevka Term";
    family = "Iosevka Kian Term";
  };

  fixed = mkSet {
    set = "KianFixed";
    sourcePlan = "iosevka-fixed";
    sourceFamily = "Iosevka Fixed";
    family = "Iosevka Kian Fixed";
  };
in
symlinkJoin {
  pname = "iosevka-kian";
  inherit (sans) version;
  paths = [
    sans
    term
    fixed
  ];

  passthru = {
    inherit sans term fixed;
  };
}
