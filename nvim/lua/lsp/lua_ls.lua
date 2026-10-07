-- lua/lsp/lua_ls.lua

return {
  -- 1. サーバーの実行コマンド
  cmd = { "lua-language-server" },

  -- 2. プロジェクトのルートを判定するマーカー
  -- ここに含まれるファイルがあるディレクトリを「プロジェクトの根」とみなします
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },

  -- 対象とするファイルタイプ
  filetypes = { "lua" },

  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- 3. インレイヒントの設定
      hint = {
        enable = true, -- 型情報などをコード上に表示する
        arrayIndex = "Enable",
        setType = true,
      },
      -- 4. 補完の挙動設定
      completion = {
        callSnippet = "Replace", -- 関数補完時に自動でカッコを補完する
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
