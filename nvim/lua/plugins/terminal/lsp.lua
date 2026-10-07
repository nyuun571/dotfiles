if not vim.g.vscode then
    return {
    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        cmd = { "Mason", "MasonUpdate", "MasonLog", "MasonInstall", "MasonUninstall", "MasonUninstallAll" },
        config = true,
    },
    {
        -- 【変更】Mason v2.0から organization が "mason-org" に変更されました
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
        { "mason-org/mason.nvim"},
        { "neovim/nvim-lspconfig" },
        },
        -- 【追加】Neovim起動時ではなく、ファイルを開いた瞬間にLSPをロードする（起動高速化）
        event = { "BufReadPre", "BufNewFile" },
        config = function()
          -- ロード完了後に lua/lsp/init.lua を呼び出す
        require("lsp.init")
        end,
      },
    }
end
