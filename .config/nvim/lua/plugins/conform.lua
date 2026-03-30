return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      gdscript = { "gdscript-formatter" },
      caddyfile = { "caddy" },
    },
    formatters = {
      caddy = {
        command = "caddy",
        args = { "fmt", "-" },
      },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  },
}
