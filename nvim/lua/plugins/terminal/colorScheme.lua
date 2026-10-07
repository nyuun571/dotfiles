return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true, -- Wisteriaのように背景を透過
      no_italic = true,
      -- 1. ここで「自分専用の色」にCatppuccinを上書き（ハック）します
      color_overrides = {
        all = {
          -- Mocha（ダークテーマ）のベースカラーをWisteria風の紫がかったグレーに変更
          base   = "#1e1e2e",
          mantle = "#181825",
          crust  = "#11111b",
          
          -- アクセントカラーを藤色や落ち着いた色合いに上書き
          mauve  = "#cba6f7", -- メインの藤色（紫）
          pink   = "#f5c2e7", -- 明るい藤色
          blue   = "#8caaee", -- くすんだ青紫
          green  = "#a6e3a1", -- 落ち着いた緑
          text   = "#cdd6f4", -- 基本の文字色
        },
      },
      
      -- 2. 特定のハイライトを微調整する（Wisteriaの挙動を再現）
      custom_highlights = function(colors)
        return {
          -- コメントのイタリックを解除し、グレーに変更
          Comment = { fg = "#948b85", italic = false },  
        }
      end,
      
      -- 3. あなたの現在の構成に合わせたIntegrations（プラグイン連携）
      integrations = {
        treesitter = true,
        mason = true,
        rainbow_delimiters = true, -- これをtrueにするだけでカッコが色分けされます！
      },
    },
    config = function(_, opts)
      -- カスタム設定を読み込ませてからテーマを起動
      require("catppuccin").setup(opts)
      vim.cmd("colorscheme catppuccin")
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    -- VeryLazy をやめて、ファイルを開いた瞬間に確実に読み込ませる
    lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      -- おまじないとして、明示的にエンジンの設定を記述しておきます
      -- （色自体はCatppuccinが自動で塗ってくれます）
      local rainbow_delimiters = require('rainbow-delimiters')
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
      }
    end,
  }
}
