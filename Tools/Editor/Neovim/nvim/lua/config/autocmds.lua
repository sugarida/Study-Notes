-- 自動コマンド（特定のタイミングで自動実行される処理）
local autocmd = vim.api.nvim_create_autocmd

-- ヤンク（コピー）した範囲を一瞬光らせる
autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Insert モードを抜けたら IME を英数に戻す（macOS + macism がある場合のみ）
if vim.fn.executable("macism") == 1 then
  autocmd("InsertLeave", {
    callback = function()
      vim.fn.jobstart({ "macism", "com.apple.keylayout.ABC" })
    end,
  })
end
