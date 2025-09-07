return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft.java = { "clang-format" }

      -- Register custom formatters
      require("conform").formatters.gdformat3 = {
        command = "gdformat3",
        args = { "-" },
      }
      require("conform").formatters.gdformat4 = {
        command = "gdformat4",
        args = { "-" },
      }

      -- Auto-detect Godot version from project
      local function detect_godot_version()
        -- Check for project.godot file
        local project_file = vim.fn.findfile("project.godot", ".;")
        if project_file ~= "" then
          local file = io.open(project_file, "r")
          if file then
            local content = file:read "*all"
            file:close()

            -- Check for Godot 4 features string
            if content:match 'config/features=PackedStringArray%("4%.%w*"' then
              return "godot4"
            -- If not found, assume Godot 3
            else
              return "godot3"
            end
          end
        end
        return "godot4" -- Default to Godot 4
      end

      -- Set formatter based on detected version
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.gdscript = function()
        local version = detect_godot_version()
        if version == "godot3" then
          return { "gdformat3" }
        else
          return { "gdformat4" }
        end
      end

      return opts
    end,
  },
}
