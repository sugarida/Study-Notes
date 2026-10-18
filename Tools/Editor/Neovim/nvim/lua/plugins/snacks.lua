-- snacks.nvim: 小さな便利機能の詰め合わせ。使う機能だけ有効にする
--   terminal  : ターミナル（VS Code の Ctrl+` 相当）
--   lazygit   : Git 操作画面（VS Code のソース管理相当）※ brew install lazygit が必要
--   picker    : あいまい検索（ファイル / 全文 / GitHub の Issue・PR）
--   gitbrowse : 今の行を GitHub のページで開く
--   bigfile   : 巨大なログを開いた時に重い機能を自動で切る
return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 900,
  opts = {
    bigfile = { enabled = true },
    picker = { enabled = true },
    terminal = { enabled = true },
    lazygit = { enabled = true },
    gitbrowse = { enabled = true },
  },
  -- stylua: ignore
  keys = {
    -- ターミナル
    { "<C-/>",      function() Snacks.terminal() end, mode = { "n", "t" }, desc = "ターミナル開閉" },
    { "<leader>t",  function() Snacks.terminal() end, desc = "ターミナル開閉" },
    { "<leader>T",  function() Snacks.terminal(nil, { win = { position = "float" } }) end, desc = "ターミナル（フローティング）" },

    -- 検索（VS Code の Cmd+P / Cmd+Shift+F 相当）
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "ファイルを開く" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "ファイル名で検索" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "全文検索" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "最近開いたファイル" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "開いているファイル" },
    { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "キーマップ検索" },

    -- Git
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit（Git 操作画面）" },
    { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "このファイルの履歴" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "変更ファイルを検索" },
    { "<leader>go", function() Snacks.gitbrowse() end, mode = { "n", "v" }, desc = "GitHub で開く" },

    -- GitHub（gh CLI 経由）
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "Issue 一覧" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "Pull Request 一覧" },
  },
}
