return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css",
        "python", "java", "c",
        "latex", "cpp",
        "javascript", "typescript", "tsx", "json",
        "asm",
      },
    },
  },

  -- Add this block for LaTeX support
  {
    "lervag/vimtex",
    lazy = false, -- load immediately
    config = function()
      -- PDF viewer
      vim.g.vimtex_view_method = "zathura"
      -- disable quickfix pop-up
      vim.g.vimtex_quickfix_mode = 0
      -- enable continuous compilation
      vim.g.vimtex_compiler_latexmk = {
        continuous = 1,
        callback = 1,
        executable = "latexmk",
        options = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
      }
    end,
  },

  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_latexmk = {
        continuous = 1,
        callback = 1,
        executable = "latexmk",
        options = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
      }
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "ibhagwan/fzf-lua",
      -- optional but useful
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "ollama",
      instructions_file = "avante.md",
      providers = {
        ollama = {
          endpoint = "http://127.0.0.1:11434",
          model = "deepseek-coder:6.7b-instruct",
          extra_request_body = {
            options = {
              num_ctx = 8192,
            },
          },
        },
      },
    },
  },
}
