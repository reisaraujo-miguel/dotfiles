return {
  {
    "yetone/avante.nvim",
    opts = {
      auto_suggestions_provider = "deepseek",
      provider = "deepseek",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-coder",
          extra_request_body = {
            max_tokens = 8192,
          },
        },
      },
      web_search_engine = {
        provider = "google", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
        proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
      },
    },
  },
}
