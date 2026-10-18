-- Claude Code 連携（VS Code の Claude Code 拡張と同じ仕組み）
--   - 右側に Claude Code を開く
--   - 選択範囲やファイルを Claude に渡せる
--   - Claude の変更提案を差分で表示し、承認 / 却下できる
-- 事前に Claude Code 本体のインストールが必要（setup-macos.md 参照）
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  -- これらのコマンドを初めて使った時に読み込む（起動を遅くしない）
  cmd = {
    "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeSelectModel", "ClaudeCodeAdd",
    "ClaudeCodeSend", "ClaudeCodeTreeAdd", "ClaudeCodeStatus", "ClaudeCodeStart",
    "ClaudeCodeStop", "ClaudeCodeOpen", "ClaudeCodeClose",
    "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny", "ClaudeCodeCloseAllDiffs",
  },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.40,
    },
  },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude Code 開閉" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude Code へ移動" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "過去の会話を再開" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "直前の会話を続ける" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "このファイルを渡す" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "選択範囲を渡す" },
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "ツリーのファイルを渡す", ft = "neo-tree" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "変更を承認" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "変更を却下" },
  },
}
