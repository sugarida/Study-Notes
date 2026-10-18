-- 自分で追加するキーマップ
-- <leader> = Space。desc を付けておくと which-key のメニューに表示される
local map = vim.keymap.set

-- 基本操作
map("n", "<leader>w", "<cmd>write<cr>", { desc = "保存" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "閉じる" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "検索ハイライトを消す" })

-- ウィンドウ移動（Ctrl + hjkl）
map("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ" })
map("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ" })
map("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ" })
map("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ" })
-- ターミナル（Claude Code など）の中から左の編集画面へ戻る
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "左のウィンドウへ" })

-- ビジュアルモードでインデントしても選択を解除しない
map("v", "<", "<gv", { desc = "インデントを減らす" })
map("v", ">", ">gv", { desc = "インデントを増やす" })
