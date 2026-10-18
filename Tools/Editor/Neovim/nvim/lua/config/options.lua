-- エディタの基本動作
-- 各オプションの詳細は :help 'オプション名' で確認できる（例: :help 'number'）
local opt = vim.opt

-- 表示
opt.number = true          -- 行番号
opt.relativenumber = true  -- 相対行番号（5j のような移動回数が一目でわかる）
opt.cursorline = true      -- カーソル行をハイライト
opt.signcolumn = "yes"     -- 左端の記号欄を常に表示（Git差分やエラー表示でガタつかない）
opt.termguicolors = true   -- フルカラー表示
opt.background = "dark"    -- ターミナルが白背景でも常にダーク配色にする
opt.scrolloff = 8          -- 上下に最低8行の余白を残してスクロール
opt.wrap = false           -- 長い行を折り返さない（ログや config を見やすく）
opt.list = true            -- タブや行末スペースを可視化（YAML のミス防止）
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- インデント（YAML / JSON / Terraform に合わせて 2 スペース）
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- 検索
opt.ignorecase = true  -- 大文字小文字を区別しない
opt.smartcase = true   -- ただし大文字を含めたら区別する

-- 操作
opt.mouse = "a"                -- マウス操作を有効化（慣れるまでの保険）
opt.clipboard = "unnamedplus"  -- macOS のクリップボードと共有
opt.splitright = true          -- 縦分割は右に開く
opt.splitbelow = true          -- 横分割は下に開く
opt.undofile = true            -- 閉じても undo 履歴を保持
opt.updatetime = 250           -- 反応速度（Git 差分表示などが速くなる）
opt.timeoutlen = 400           -- キー連打の待ち時間（which-key の表示タイミング）
opt.confirm = true             -- 未保存で閉じようとしたら確認
