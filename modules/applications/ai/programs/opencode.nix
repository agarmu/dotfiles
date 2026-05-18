{
  flake.modules.homeManager.ai =
    { config, lib, ... }:
    {
      programs.opencode = {
        enable = true;

        settings = {
          autoshare = false;
          autoupdate = false;
        };

        context = lib.concatStringsSep "\n\n" (lib.attrValues config.ai.shared.rules);

        skills = lib.mapAttrs (
          name: agent:
          let
            toolsList = "skills:\n" + lib.concatMapStrings (t: "  - ${t}\n") agent.tools;
          in
          ''
            ---
            name: ${name}
            description: ${agent.description}
            ${toolsList}---
            ${agent.prompt}
          ''
        ) config.ai.shared.agents;

        commands = lib.mapAttrs (
          _name: cmd:
          let
            toolsList = "skills:\n" + lib.concatMapStrings (t: "  - ${t}\n") cmd.tools;
          in
          ''
            ---
            description: ${cmd.description}
            ${toolsList}---
            ${cmd.prompt}
          ''
        ) config.ai.shared.tools;
      };
    };
}
