-- nvim/lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- FileTypeイベントの取りこぼしを防ぐため、遅延読み込みは無効化
  lazy = false,
  
  -- ensure_installed 廃止に伴う新しいインストール手法
  build = ":TSUpdate",

  config = function()
    -- 旧来の nvim-treesitter.configs の setup() は完全に廃止されたため呼ばない

    -- ハイライトの実行（Neovim 0.12 ネイティブAPIへの完全委譲）
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NativeTreesitterHighlight", { clear = true }),
      callback = function(ev)
        local lang = vim.bo[ev.buf].filetype
        
        -- 0.12仕様: 未インストールの言語や特殊バッファでもエラーを出さず nil が返る
        local parser = vim.treesitter.get_parser(ev.buf, lang)
        
        if parser then
          -- パーサーが実際に存在する場合のみ、本体のAPIでハイライトを開始
          vim.treesitter.start(ev.buf, lang)
        end
      end,
    })
  end,
}
