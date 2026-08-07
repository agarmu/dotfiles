{
  flake.modules.homeManager.ai = _: {
    stylix.targets.opencode.colors.enable = false;
    programs.opencode = {
      enable = true;
      tui.theme = "system";
      settings = {
        autoshare = false;
        autoupdate = false;
        provider = {
          purdue = {
            npm = "@ai-sdk/openai-compatible";
            name = "Purdue GenAI";
            options = {
              baseURL = "https://genai.rcac.purdue.edu/api";
            };
            models = {
              "gpt-oss:120b" = {
                name = "GPT-OSS 120B";
              };
              "qwen3-coder:latest" = {
                name = "Qwen3 Coder";
              };
              "qwen3.6:27b" = {
                name = "Qwen3.6 27B";
              };
              "llama4:latest" = {
                name = "Llama 4";
              };
              "gemma4:26b-a4b" = {
                name = "Gemma 4 26B";
              };
              "qwen3:32b" = {
                name = "Qwen3 32B";
              };
              "deepseek-r1:32b" = {
                name = "DeepSeek R1 32B";
              };
            };
          };
        };
      };
    };
  };
}
