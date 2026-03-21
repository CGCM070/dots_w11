-- DAP UI Persistence Plugin
-- Override LazyVim's auto-close behavior so test output stays visible
-- after execution completes.
--
-- LazyVim's dap/core.lua registers listeners with the key "dapui_config"
-- that call dapui.close({}) on event_terminated and event_exited.
-- We REMOVE those listeners so the UI stays open for inspection.
--
-- For tests: only the bottom layout (REPL + console) opens automatically.
-- For full debugging: use <leader>du to toggle all panels.
-- Close test output with <leader>tc or <leader>to (toggle).

return {
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        -- Layout 1: sidebar (left) — for full debugging
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        -- Layout 2: bottom — for test output
        -- Console (System.out) gets 85% width, REPL (test results) gets 15%
        {
          elements = {
            { id = "repl", size = 0.15 },
            { id = "console", size = 0.85 },
          },
          size = 12,
          position = "bottom",
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      -- Auto-open ONLY bottom layout (layout 2: REPL + console) when session starts.
      -- This avoids showing the empty sidebar panels (scopes, breakpoints, etc.)
      -- during test runs. For full debugging, user can toggle all with <leader>du.
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ layout = 2 })
      end

      -- REMOVE LazyVim's auto-close listeners — keep output visible
      dap.listeners.before.event_terminated["dapui_config"] = nil
      dap.listeners.before.event_exited["dapui_config"] = nil
    end,
    keys = {
      -- Debug keymaps (<leader>d group)
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Toggle DAP UI (all panels)",
      },
      {
        "<leader>dU",
        function()
          require("dapui").close({})
        end,
        desc = "Close DAP UI",
      },
      -- Test keymaps (<leader>t group) — appear in +test which-key menu
      {
        "<leader>to",
        function()
          require("dapui").toggle({ layout = 2 })
        end,
        desc = "Toggle Test Output",
      },
      {
        "<leader>tc",
        function()
          require("dapui").close({})
        end,
        desc = "Close Test Output",
      },
    },
  },
}
