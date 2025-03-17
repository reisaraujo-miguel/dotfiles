-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- import/override with your plugins folder

  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.diagnostics.tiny-inline-diagnostic-nvim" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },
  { import = "astrocommunity.color.nvim-highlight-colors" },
  { import = "astrocommunity.file-explorer.telescope-file-browser-nvim" },
  { import = "astrocommunity.utility.hover-nvim" },
  -- { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  -- { import = "astrocommunity.completion.copilot-cmp" },

  -- Language packs
  { import = "astrocommunity.pack.lua" },
  -- { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.bash" },
  -- { import = "astrocommunity.pack.cpp" },
  -- { import = "astrocommunity.pack.cmake" },
  -- { import = "astrocommunity.pack.go" },
  -- { import = "astrocommunity.pack.docker" },
  -- { import = "astrocommunity.pack.typescript-all-in-one" },
  -- { import = "astrocommunity.pack.python" },
  -- { import = "astrocommunity.pack.php" },
}
