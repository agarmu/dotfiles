{
  flake.modules.homeManager.dev =
    { config, ... }:
    {
      programs.nixvim.plugins.treesitter.grammarPackages =
        with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          css
          html
          javascript
          jsdoc
          tsx
          typescript
        ];
    };
}
