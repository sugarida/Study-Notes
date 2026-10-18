-- 行ごとの Git 差分表示（左端に 追加 / 変更 / 削除 の印が出る）
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = true, -- カーソル行に「誰がいつ変更したか」を薄く表示
    on_attach = function(buf)
      local gs = require("gitsigns")
      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
      end
      map("]h", function() gs.nav_hunk("next") end, "次の変更箇所")
      map("[h", function() gs.nav_hunk("prev") end, "前の変更箇所")
      map("<leader>gh", gs.preview_hunk, "変更内容をプレビュー")
      map("<leader>ga", gs.stage_hunk, "この変更をステージ")
      map("<leader>gr", gs.reset_hunk, "この変更を取り消す")
      map("<leader>gb", gs.blame_line, "この行の blame")
      map("<leader>gd", gs.diffthis, "差分を左右に表示")
    end,
  },
}
