local opt = vim.opt

opt.number = true

opt.relativenumber = true

--タブの設定
opt.tabstop = 4      -- 「見た目」の幅
opt.shiftwidth = 4   -- 「自動インデント」の幅
opt.expandtab = true -- 「タブをスペースに変換」する

--コメント改行自動コメント化を無効化
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
})
