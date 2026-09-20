# CCNP Enterprise 合格シナリオ 🛣️
**ENCOR 350-401 ＋ ENARSI 300-410 / 「Ping-t ＋ 手を動かす」で受かるための全体計画**

> このディレクトリは「問題集だけで受かる勉強」ではなく、
> **コマンドを自分の手で打てる状態にしてから受験する**ための進行表です。
> Ping-t は *知識の穴を見つけるセンサー*、ラボは *知識を手に定着させる装置* として使い分けます。

---

## 🎯 ゴール設定

| 項目 | 内容 |
|------|------|
| 取得資格 | CCNP Enterprise |
| 必須試験 | **ENCOR 350-401**（コア）＋ **ENARSI 300-410**（コンセントレーション） |
| 想定学習期間 | 約 **8 か月**（ENCOR 5 か月 → ENARSI 3 か月） |
| 想定学習時間 | 平日 2h / 休日 4h（週 ≒ 18h） |
| 合格基準 | 非公開（スコア 750-850 前後と言われるが公表されていない） |
| 到達レベル | 「show の出力を見て、どこが壊れているか説明できる」 |

> ⚠️ 出題範囲・試験時間・受験料は改定されるため、**必ず公式の Exam Topics を最新版で確認**すること。
> ここに書いた比率は計画立案用の目安。

### ENCOR 350-401 の出題比率（計画用の目安）

| 分野 | 比率 | このリポジトリの対応ラボ |
|------|------|------|
| Architecture | 15% | `01-encor/lab-07-*`（座学中心） |
| Virtualization | 10% | `01-encor/lab-05-*`（VRF / GRE） |
| Infrastructure（L2/L3/Wireless/IPサービス） | **30%** | `lab-01` 〜 `lab-04`, `lab-06` |
| Network Assurance | 10% | `commands/show-debug-troubleshooting.md` |
| Security | 20% | `01-encor/lab-07-*` |
| Automation | 15% | `01-encor/lab-08-*` |

**Infrastructure + Assurance で 40%**。ここは全部コマンドで殴れる領域なので、ラボの主戦場。

---

## 🔁 学習の基本ループ（これが本体）

```
① Ping-t で 30〜40 問 解く（20分）
        ↓ 間違えた / 勘で当てた問題をピックアップ
② その論点を "ラボで再現" する（40〜60分）
        ↓ config を打つ → show で確認 → わざと壊す → debug で見る
③ 結果を .md にメモする（15分）
        ↓ 「打ったコマンド」「見た show 出力」「壊れたときの症状」
④ 翌日、同じ論点を "何も見ずに" 打ち直す（10分）
```

### なぜ「わざと壊す」のか
試験問題の大半は **「正常時の設定」ではなく「異常時の見分け方」** を聞いてくる。
OSPF が上がらない理由（Area 不一致 / Hello-Dead 不一致 / MTU 不一致 / Network Type 不一致 / 認証不一致）は、
**5 回壊して 5 回 `show ip ospf neighbor` を見た人**だけが即答できる。

### コマンド定着の 3 段階
| 段階 | 状態 | 判定方法 |
|------|------|----------|
| Lv.1 | 見れば意味が分かる | Ping-t の選択肢が読める |
| Lv.2 | 白紙から打てる | 空の機器に 5 分で構築できる |
| Lv.3 | 壊れた原因を show で特定できる | 他人が仕込んだ不具合を 10 分で直せる |

**ENCOR は Lv.2、ENARSI は Lv.3 が要求水準。**

---

## 🗓️ フェーズ計画

### Phase 0：環境構築（Week 0 / 3日）
- ラボ環境を決めて動かす → `00-lab-setup/lab-environment.md`
- 共通トポロジを保存 → `00-lab-setup/base-topology.md`
- **ここで妥協するとシナリオ全体が崩れる。最優先。**

### Phase 1：L2 基盤（Week 1-3）
`01-encor/lab-01-l2-stp-etherchannel.md`
- VLAN / Trunk / STP（RSTP・MST）/ EtherChannel（LACP・PAgP）
- CCNA の復習に見えるが、**MST と LACP の細部が CCNP の出題点**

### Phase 2：IGP（Week 4-7）
`01-encor/lab-02-ospf.md`
- OSPFv2/v3、Area 種別、LSA タイプ、Network Type、認証、集約
- **ENCOR で一番配点が取りやすい。ここを厚く。**

### Phase 3：BGP（Week 8-10）
`01-encor/lab-03-bgp.md`
- eBGP/iBGP、ネイバー確立条件、アトリビュート、経路選択順
- 経路選択順（Weight → LocalPref → ...）は**呪文として暗記＋ラボで確認**

### Phase 4：可用性・NAT・トンネル（Week 11-13）
- `01-encor/lab-04-fhrp-nat.md`：HSRP / VRRP / GLBP / NAT / PAT
- `01-encor/lab-05-vrf-gre-ipsec.md`：VRF-Lite / GRE / IPsec / VXLAN・LISP（概念）

### Phase 5：無線・セキュリティ・QoS・アーキ（Week 14-16）
- `01-encor/lab-06-wireless.md`：AP モード、CAPWAP、WLC 設定の流れ
- `01-encor/lab-07-security-qos.md`：ACL、CoPP、AAA、802.1X、QoS
- **無線とアーキは実機が無くても落とせない。座学＋WLC の GUI 動画で補完。**

### Phase 6：自動化（Week 17-18）
`01-encor/lab-08-automation.md`
- NETCONF / RESTCONF / YANG / Python(ncclient, requests) / Ansible / JSON-XML-YAML
- **DevNet Sandbox を使えば実機ゼロで手を動かせる**

### Phase 7：ENCOR 総仕上げ → 受験（Week 19-20）
- Ping-t 模擬試験で 90% 以上を 3 回連続
- `commands/ccnp-command-cheatsheet.md` を白紙から再現できるか確認
- **受験日を先に予約する**（締切がないと終わらない）

### Phase 8：ENARSI（Week 21-32）
`02-enarsi/README.md` 参照
- EIGRP / OSPF 深堀り / BGP 深堀り / 再配送 / VPN / インフラサービス
- **ENARSI はトラブルシュート試験。Lv.3 まで上げる**

---

## 📁 ディレクトリ構成

```
Network/CCNP/
├── README.md                       ← このファイル（全体シナリオ）
├── 00-lab-setup/
│   ├── lab-environment.md          ← 環境の選び方と構築手順
│   └── base-topology.md            ← 共通トポロジ＋初期コンフィグ
├── 01-encor/
│   ├── README.md                   ← ENCOR の進め方
│   ├── lab-01-l2-stp-etherchannel.md
│   ├── lab-02-ospf.md
│   ├── lab-03-bgp.md
│   ├── lab-04-fhrp-nat.md
│   ├── lab-05-vrf-gre-ipsec.md
│   ├── lab-06-wireless.md
│   ├── lab-07-security-qos.md
│   └── lab-08-automation.md
├── 02-enarsi/
│   └── README.md                   ← ENARSI の進め方とラボ課題
├── commands/
│   ├── ccnp-command-cheatsheet.md  ← コマンド逆引き（試験直前用）
│   └── show-debug-troubleshooting.md ← 障害切り分けフロー
└── progress/
    └── weekly-log-template.md      ← 週次ログのテンプレ
```

---

## 🧰 教材の役割分担

| 教材 | 役割 | 使い方 |
|------|------|--------|
| **Ping-t** | 知識の穴の検出 | 毎日 30-40 問。**間違えた問題は必ずラボに落とす** |
| **ラボ（CML/EVE-NG）** | コマンドの定着 | 週 5 日、1 日 40-60 分 |
| **公式 Exam Topics** | 範囲の確認 | 月 1 回、章立てと自分の進捗を突き合わせる |
| **Cisco Docs / Configuration Guide** | 一次情報 | 「なぜ？」が出たら必ず公式を引く |
| **DevNet Sandbox** | 自動化の実機代替 | Phase 6 で使用 |
| **このリポジトリ** | 自分専用の教科書 | **書いてないことは身についてない、の指標** |

> 📌 **Ping-t の使い方の注意**
> 「金のメダルを増やす」ことが目的化すると、選択肢の形を覚えただけで合格した気になる。
> **正解しても「なぜ他の選択肢が誤りか」を言えない問題は、未修得として扱う。**

---

## ✅ 各フェーズの卒業条件

フェーズを次に進めてよいのは、以下を満たしたときだけ。

1. 該当ラボを **白紙のトポロジから 1 回、見ないで構築できた**
2. そのラボの「壊し方」を **3 パターン試して、show で原因を特定できた**
3. 該当分野の Ping-t 正答率が **85% 以上**
4. ノート（.md）に **自分の言葉で** 要点を書いた

> 「時間が来たから次へ」ではなく「条件を満たしたから次へ」。
> 遅れたら**計画の方を書き換える**（進度を偽らない）。

---

## 🚦 つまずいたときの対処

| 症状 | 対処 |
|------|------|
| ラボを組むのに時間がかかりすぎる | `base-topology.md` の初期コンフィグを使い回す |
| Ping-t の正答率が上がらない | 解説を読む前に **ラボで再現** してから解説を読む |
| 無線・アーキが覚えられない | コマンドが無い分野なので、**図を自分で描いて .md に貼る** |
| 自動化が苦手 | Python を書くより先に **curl / RESTCONF で 1 回叩く** |
| 時間が取れない週がある | ラボを捨てずに **Ping-t を捨てる**（手が鈍る方が損失が大きい） |

---

## 📝 記録のルール

- 週次ログは `progress/weekly-log-template.md` をコピーして `progress/2026-Wxx.md` に
- ラボで詰まった点は**その日のうちに**該当ラボ .md の「ハマりどころ」に追記
- コマンドを新しく覚えたら `commands/ccnp-command-cheatsheet.md` に追記

---

Happy Labbing 🔧✨
