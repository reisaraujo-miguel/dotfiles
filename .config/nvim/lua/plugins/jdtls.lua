return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  opts = function(_, opts)
    local utils = require "astrocore"

    -- Workspace
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
    vim.fn.mkdir(workspace_dir, "p")

    -- JDTLS command
    local jdtls_cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-javaagent:" .. vim.fn.expand "$MASON/share/jdtls/lombok.jar",
      "-Xms2g",
      "-Xmx4g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      vim.fn.expand "$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
      "-configuration",
      vim.fn.expand "$MASON/share/jdtls/config",
      "-data",
      workspace_dir,
    }

    -- Project root detection
    local root_markers = {
      ".git",
      "build.gradle",
      "build.gradle.kts",
      "pom.xml",
      "settings.gradle",
      "settings.gradle.kts",
      "gradlew",
      "mvnw",
    }

    -- Java settings
    local java_settings = {
      java = {
        eclipse = { downloadSources = true },
        maven = { downloadSources = true },
        configuration = { updateBuildConfiguration = "interactive" },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        inlayHints = { parameterNames = { enabled = "all" } },
        saveActions = { organizeImports = true },
        compiler = {
          source = "21",
          target = "21",
          release = "21",
          compliance = "21",
          encoding = "UTF-8",
        },
        format = {
          enabled = false,
        },
      },
    }

    -- LSP capabilities
    local capabilities = {
      workspace = {
        configuration = true,
        workspaceFolders = true,
      },
      textDocument = {
        completion = { completionItem = { snippetSupport = true } },
      },
    }

    -- Debugger and testing bundles
    local init_options = {
      bundles = {
        vim.fn.expand "$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
        (table.unpack or unpack)(vim.split(vim.fn.glob "$MASON/share/java-test/*.jar", "\n", {})),
      },
    }

    -- On attach function
    local on_attach = function(client, bufnr)
      require("jdtls").setup_dap { hotcodereplace = "auto" }

      local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
      if astrolsp_avail then astrolsp.on_attach(client, bufnr) end

      local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

      -- Essential keybindings
      map("n", "<leader>co", function() require("jdtls").organize_imports() end, "Organize imports")
      map("n", "<leader>cg", function() require("jdtls").generate_toString() end, "Generate toString")
      map("n", "<leader>ce", function() require("jdtls").generate_hashCodeEquals() end, "Generate hashCode/equals")
      map("n", "<leader>ca", function() require("jdtls").generate_accessors() end, "Generate accessors")
      map("n", "<leader>cr", function() require("jdtls").extract_variable() end, "Extract variable")
      map("n", "<leader>cm", function() require("jdtls").extract_method() end, "Extract method")
    end

    return utils.extend_tbl({
      cmd = jdtls_cmd,
      root_dir = vim.fs.root(0, root_markers),
      settings = java_settings,
      capabilities = capabilities,
      init_options = init_options,
      filetypes = { "java" },
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
        allow_incremental_sync = true,
      },
    }, opts)
  end,
  config = function(_, opts)
    local jdtls_augroup = vim.api.nvim_create_augroup("jdtls_config", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      group = jdtls_augroup,
      callback = function()
        if opts.root_dir and opts.root_dir ~= "" then
          require("jdtls").start_or_attach(opts)
        else
          require("astrocore").notify(
            "jdtls: No project root detected. Please open a Java project with build files.",
            vim.log.levels.WARN
          )
        end
      end,
    })
  end,
}
