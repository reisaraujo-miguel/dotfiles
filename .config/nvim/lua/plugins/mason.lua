-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer para automaticamente automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",
        "ansible-language-server",

        -- install linters
        "ansible-lint",

        -- install formatters
        "stylua",
        "prettier",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}
