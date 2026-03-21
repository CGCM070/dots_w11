-- Configuración LSP completa para HTML, CSS, TypeScript y más
return {
  -- NOTA: nvim-jdtls ya está configurado por LazyVim en lang.java
  -- No es necesario configurarlo manualmente

  -- Servidores LSP adicionales
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    opts = {
      servers = {
        -- HTML
        html = {
          filetypes = { "html", "htmldjango", "htmlangular" },
          settings = {
            html = {
              format = {
                templating = true,
                wrapLineLength = 120,
                wrapAttributes = "auto",
              },
              hover = {
                documentation = true,
                references = true,
              },
            },
          },
        },
        -- CSS
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
        -- Emmet para snippets HTML/CSS
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "astro",
          },
          init_options = {
            html = {
              options = {
                ["bem.enabled"] = true,
              },
            },
          },
        },
        -- JSON
        jsonls = {
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
        },
      },
    },
  },

  -- Configuración de Mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP Servers
        "jdtls",
        "html-lsp",
        "css-lsp",
        "emmet-ls",
        "json-lsp",
        -- Linters y Formatters
        "prettier",
        "eslint_d",
        "stylelint",
        "google-java-format",
        "checkstyle",
        -- DAP (Debuggers)
        "java-debug-adapter",
        "java-test",
      },
    },
  },

  -- Formateo automático
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        -- Checkstyle deshabilitado temporalmente - causa muchos warnings molestos
        -- java = { "checkstyle" },
        css = { "stylelint" },
        scss = { "stylelint" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      },
    },
  },
}
