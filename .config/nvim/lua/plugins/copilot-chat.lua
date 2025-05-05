return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      system_prompt = "CUSTOM",

      model = "claude-3.7-sonnet-thought",

      prompts = {
        CUSTOM = {
          system_prompt = [[
          When answering my “how to” questions, first provide a direct solution to my specific request, then suggest a potentially better approach if one exists. For the alternative approach, briefly explain its advantages.

          For code generation:
          1. Prioritize performance optimizations that meaningfully impact execution time or resource usage
          2. Maintain readable code with clear variable names and appropriate comments for complex logic
          3. Use concise patterns and avoid unnecessary verbosity
          4. Always explain key optimization decisions or tradeoffs you've made.

          Please highlight potential edge cases I should consider.
          ]],
        },
      },
    },
  },
}
