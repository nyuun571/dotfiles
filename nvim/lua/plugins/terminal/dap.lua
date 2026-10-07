return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
          -- macOS では CodeLLDB を使用する。
          -- WSL/Linux ではシステムの GDB 14+ を直接使うので、
          -- Mason では CodeLLDB だけ用意しておけばよい。
          ensure_installed = { "codelldb" },
          automatic_installation = true,
        },
      },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start / Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: Conditional Breakpoint",
      },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Terminate" },
      {
        "<leader>de",
        function() require("dapui").eval() end,
        mode = { "n", "v" },
        desc = "Debug: Evaluate",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "stacks", size = 0.25 },
              { id = "breakpoints", size = 0.20 },
              { id = "watches", size = 0.20 },
            },
            size = 42,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.50 },
              { id = "console", size = 0.50 },
            },
            size = 12,
            position = "bottom",
          },
        },
      })

      -- デバッグ開始時に UI を開き、終了時に閉じる。
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- ブレークポイント等の見た目。
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

      local function executable_path()
        return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
      end

      local is_mac = vim.fn.has("macunix") == 1
      local is_linux = vim.fn.has("unix") == 1 and not is_mac

      if is_mac then
        -- Mason が ~/.local/share/nvim/mason/bin/codelldb にリンクを作るため、
        -- 通常は command = "codelldb" で利用できる。
        dap.adapters.codelldb = {
          type = "executable",
          command = "codelldb",
        }

        dap.configurations.c = {
          {
            name = "Launch (CodeLLDB)",
            type = "codelldb",
            request = "launch",
            program = executable_path,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
          {
            name = "Attach (CodeLLDB)",
            type = "codelldb",
            request = "attach",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      elseif is_linux then
        -- WSL/Linux は GDB 14+ の組み込み DAP を利用する。
        dap.adapters.gdb = {
          type = "executable",
          command = "gdb",
          args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
        }

        dap.configurations.c = {
          {
            name = "Launch (GDB)",
            type = "gdb",
            request = "launch",
            program = executable_path,
            cwd = "${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
          },
          {
            name = "Attach process (GDB)",
            type = "gdb",
            request = "attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      -- 同じ native debugger 設定を流用できる言語。
      dap.configurations.cpp = dap.configurations.c
      dap.configurations.rust = dap.configurations.c
      dap.configurations.zig = dap.configurations.c
    end,
  },
}
