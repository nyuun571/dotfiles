-- lua/lsp/rust-analyzer.lua

return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },

  settings = {
    ["rust-analyzer"] = {
      
      -- 【修正】checkOnSave ではなく check を使用する
      check = {
        command = "clippy",
      },

      cargo = {
        allFeatures = true,
        buildScripts = {
          enable = true,
        },
      },

      procMacro = {
        enable = true,
      },

      inlayHints = {
        typeHints = { enable = true },
        parameterHints = { enable = true },
        chainingHints = { enable = true },
        closingBraceHints = { enable = true, minLines = 25 },
        maxLength = 25,
      },

      diagnostics = {
        enable = true,
        experimental = {
          enable = true,
        },
      },
    },
  },
}
