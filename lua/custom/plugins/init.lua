-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    {
        "github/copilot.vim",
        event = "InsertEnter",
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.keymap.set("i", "<C-j>", function()
            return vim.fn["copilot#Accept"]()
            end, { expr = true })
        end,
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
            { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
            { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        opts = {
            -- See Configuration section for options
        },
        -- See Commands section for default commands if you want to lazy load on them
    },

    {
        "mfussenegger/nvim-dap",
        keys = {
          {
            "<leader>dc",
            function()
              require("dap").continue()
            end,
            desc = "[D]ap [C]ontinue",
          },
          {
            "<leader>db",
            function()
              require("dap").toggle_breakpoint()
            end,
            desc = "[D]ap [B]reakpoint",
          },
          {
            "<leader>dt",
            function()
              require("dap").terminate()
            end,
            desc = "[D]ap [T]erminate",
          },
          {
            "<leader>dr",
            function()
              require("dap").repl.toggle()
            end,
            desc = "[D]ap [R]epl",
          },
          {
            "<leader>dn",
            function()
              require("dap").step_over()
            end,
            desc = "[D]ap [N]ext",
          },
          {
            "<leader>di",
            function()
              require("dap").step_into()
            end,
            desc = "[D]ap [I]nto",
          },
          {
            "<leader>do",
            function()
              require("dap").step_out()
            end,
            desc = "[D]ap [O]ut",
          },
          {
            "<leader>dl",
            function()
              require("dap").run_last()
            end,
            desc = "[D]ap [L]ast",
          },
        },
        config = function()
          local dap = require("dap")
          dap.adapters.gdb = {
            type = "executable",
            command = vim.fn.exepath("gdb"),
            args = { "-i", "dap", "--eval-command", "set print pretty on" },
        }
        dap.configurations.cpp = {
          {
            name = "Launch",
            type = "gdb",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
          },
          {
            name = "Select and attach to process",
            type = "gdb",
            request = "attach",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            pid = function()
              local name = vim.fn.input("Executable name (filter): ")
              return require("dap.utils").pick_process({ filter = name })
            end,
            cwd = "${workspaceFolder}",
          },
          {
            name = "Attach to gdbserver :1234",
            type = "gdb",
            request = "attach",
            target = "localhost:1234",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
          },
        }
      end,
    },

    "ravenxrz/DapInstall.nvim",
    -- "ravenxrz/nvim-dap",
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-dap",
      },
      opts = function()
        local dap, dapui = require("dap"), require("dapui")
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
        return {
          enabled = true,
          enabled_commands = true,
        }
      end,
    },
    {
        'Civitasv/cmake-tools.nvim',
        config = function()
            require("cmake-tools").setup {
                cmake_command = "cmake", -- this is used to specify cmake command path
                cmake_regenerate_on_save = true, -- auto generate when save CMakeLists.txt
                cmake_generate_options = { "-GNinja", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
                cmake_build_options = {}, -- this will be passed when invoke `CMakeBuild`
                cmake_build_directory = ".build", -- this is used to specify generate directory for cmake
                cmake_build_directory_prefix = "", -- when cmake_build_directory is set to "", this option will be activated
                cmake_soft_link_compile_commands = true, -- this will automatically make a soft link from compile commands file to project root dir
                cmake_compile_commands_from_lsp = false, -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
                cmake_kits_path = nil, -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
                cmake_variants_message = {
                    short = { show = true }, -- whether to show short message
                    long = { show = true, max_length = 40 } -- whether to show long message
                },
                cmake_dap_configuration = { -- debug settings for cmake
                    name = "cpp",
                    type = "codelldb",
                    request = "launch",
                    stopOnEntry = false,
                    runInTerminal = true,
                    console = "integratedTerminal",
                },
                cmake_always_use_terminal = false, -- if true, use terminal for generate, build, clean, install, run, etc, except for debug, else only use terminal for run, use quickfix for others
                cmake_quickfix_opts = { -- quickfix settings for cmake, quickfix will be used when `cmake_always_use_terminal` is false
                    show = "always", -- "always", "only_on_error"
                    position = "belowright", -- "bottom", "top"
                    size = 10,
                },
                cmake_terminal_opts = { -- terminal settings for cmake, terminal will be used for run when `cmake_always_use_terminal` is false or true, will be used for all tasks except for debug when `cmake_always_use_terminal` is true
                    name = "Main Terminal",
                    prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
                    split_direction = "horizontal", -- "horizontal", "vertical"
                    split_size = 11,
                
                    -- Window handling
                    single_terminal_per_instance = true, -- Single viewport, multiple windows
                    single_terminal_per_tab = true, -- Single viewport per tab
                    keep_terminal_static_location = true, -- Static location of the viewport if avialable
                
                    -- Running Tasks
                    start_insert_in_launch_task = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
                    start_insert_in_other_tasks = false, -- If you want to enter terminal with :startinsert upon launching all other cmake tasks in the terminal. Generally set as false
                    focus_on_main_terminal = false, -- Focus on cmake terminal when cmake task is launched. Only used if cmake_always_use_terminal is true.
                    focus_on_launch_terminal = false, -- Focus on cmake launch terminal when executable target in launched.
                },
            }
            local map = vim.api.nvim_set_keymap
            map("n", "cg", ":CMakeGenerate<cr>", { noremap = true, silent = true })
            map("n", "cb", ":CMakeBuild<cr>", { noremap = true, silent = true })
        end,
    },
    {
        "fei6409/log-highlight.nvim",
        config = function()
            require("log-highlight").setup({})
        end,
    },
}
