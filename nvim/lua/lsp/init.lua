local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-- 1. Masonの初期化
mason.setup()

-- 2. サーバー名と設定ファイル名のマッピング
local servers = {
  lua_ls = "lua_ls",
  rust_analyzer = "rust-analyzer",
  gopls = "gopls"
}
local server_names = vim.tbl_keys(servers)

-- 3. Masonによる自動インストールの設定
mason_lspconfig.setup({
  ensure_installed = server_names,
  automatic_installation = true,
})

-- 共通capabilitiesの取得（0.11ネイティブ）
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- 4. 【NEW】ネイティブAPIで各サーバーの設定を「登録」する
for server_name, config_file in pairs(servers) do
  local opts = { capabilities = capabilities }
  local ok, settings = pcall(require, "lsp." .. config_file)
  
  if ok and type(settings) == "table" then
    opts = vim.tbl_deep_extend("force", opts, settings)
  end

  -- lspconfig[server].setup(opts) はもう使わない！
  vim.lsp.config(server_name, opts)
end

-- 5. 【NEW】登録したサーバーを一括で「起動(有効化)」する
vim.lsp.enable(server_names)

-- LSPによる記号(括弧など)のハイライト上書きを無効化し、Rainbowの色を優先させる
vim.api.nvim_set_hl(0, "@lsp.type.punctuation", {})

-- 6. 【NEW】補完メニューの表示設定（記事推奨の設定）
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }

-- 7. 【NEW】ネイティブの自動補完機能を有効化
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf

    -- ★ここを追加: LSPのSemantic Tokens(高度なハイライト)を無効化する★
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- サーバーが補完機能を持っている場合のみ
    if client and client.server_capabilities.completionProvider then
      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = true, -- タイピング中の自動ポップアップを有効化
      })
    end
  end,
})
