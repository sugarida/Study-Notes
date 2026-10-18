-- キーを押した後に「次に押せるキー」の一覧を表示してくれる
-- 初心者はまず Space を押して待つだけで操作を思い出せる
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    -- Space の後のメニューに表示するグループ名
    spec = {
      { "<leader>f", group = "検索" },
      { "<leader>g", group = "Git / GitHub" },
      { "<leader>a", group = "Claude Code" },
    },
  },
  keys = {
    { "<leader>?", function() require("which-key").show() end, desc = "キーマップ一覧" },
  },
}
