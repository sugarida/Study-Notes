# 設定ファイル構成について

この Neovim 設定は、保守性と可読性を重視して分割している。

---

## 全体構成

~~~text
nvim/
├─ init.lua
└─ lua/
   ├─ config/
   │  ├─ options.lua
   │  ├─ keymaps.lua
   │  ├─ autocmds.lua
   │  └─ lazy.lua
   └─ plugins/
      ├─ nvim-tree.lua
      ├─ gitsigns.lua
      ├─ neogit.lua
      ├─ octo.lua
      ├─ lsp.lua
      ├─ cmp.lua
      └─ telescope.lua
~~~

---

## 分割する理由

- 設定の責務を明確にするため
- トラブルシュートしやすくするため
- 将来の拡張・削除を容易にするため
``
