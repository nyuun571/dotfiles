local map = vim.keymap.set

--Leaderキーの設定
vim.g.mapleader = ' '
-- <leader>e で左側にサイドバーとして開く（トグル動作）
map('n', '<leader>e', ':Lex<CR>', { silent = true })

--insertモードでjjを<ESC>に設定
map("i", "jj", "<ESC>", { silent = true })
--visualモードで<Leader>jを<ESC>
map("v", "<Leader>j", "<ESC>", { silent = true })

--ノーマルモードでコメントを入力で囲う設定
local function surround()
  -- 対応する閉じ括弧のマップ
  local pairs_map = {
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
    ['<'] = '>',
  }

  -- 1文字受け取る
  vim.api.nvim_echo({ { 'wrap with: ', 'Question' } }, false, {})
  local ok, char = pcall(vim.fn.getchar)
  if not ok or char == 27  or char == 13 then
      vim.api.nvim_echo({{'invalid', 'ErrorMsg'}}, false, {})
      return
  end

  local open = vim.fn.nr2char(char)
  local close = pairs_map[open] or open  -- 括弧以外はそのまま両側に使う（例: "word"）

  -- viw で inner word を選択 → ESC → マーク '< '> から範囲取得
  vim.cmd('normal! viw\27')

  local s = vim.fn.getpos("'<")
  local e = vim.fn.getpos("'>")

  local buf = 0
  local row   = s[2] - 1   -- 0-indexed
  local s_col = s[3] - 1   -- 0-indexed
  local e_col = e[3]        -- exclusive

  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
  local word = line:sub(s_col + 1, e_col)

  -- 単語を open + word + close に置換
  vim.api.nvim_buf_set_text(buf, row, s_col, row, e_col, { open .. word .. close })

  -- カーソルを open の次（単語の先頭）に置く
  vim.api.nvim_win_set_cursor(0, { row + 1, s_col + 1 })
end

map('n', '<leader>w', surround)

--visualモードでのインデント後に元の状態に戻る
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

