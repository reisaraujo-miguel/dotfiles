return {
  {
    "yetone/avante.nvim",
    opts = {
      auto_suggestions_provider = "deepseek",
      provider = "deepseek",
      vendors = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
          max_tokens = 8192,
        },
      },
    },
  },
}
