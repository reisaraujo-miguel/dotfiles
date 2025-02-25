return {
  {
    "tiny-inline-diagnostic.nvim",
    opts = {
      preset = "simple",
      options = {
        enable_on_insert = true,
        multiple_diag_under_cursor = true,
        multilines = {
          enabled = true,
          always_show = true,
        },
      },
    },
  },
}
