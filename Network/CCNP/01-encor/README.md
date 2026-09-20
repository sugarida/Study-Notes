# ENCOR 350-401 学習ガイド 📘

> CCNP Enterprise の **コア試験**。ENCOR に受かると CCNP への足がかりと
> CCIE Enterprise Infrastructure の筆記要件の両方を満たす（要件は必ず公式で確認）。

---

## 試験の特徴

- **範囲が広く、浅い**（ENARSI は狭く深い）
- ルーティングだけでなく **無線 / セキュリティ / 自動化 / アーキテクチャ**まで出る
- コマンドを打てるだけでは足りず、**用語と概念の整理**も必要
- 逆に、Infrastructure と Assurance（合計 40% 前後）は**ラボで確実に取れる**

### 戦い方
```
コマンドで取れる 40%  → ラボで満点近くを狙う（落とさない）
座学が必要な 60%      → Ping-t + 図解ノートで 75〜80% を狙う
```

---

## ラボ一覧と進め方

| # | ラボ | 週 | 重点 | 卒業条件 |
|---|------|----|----|------|
| 01 | [L2 / STP / EtherChannel](lab-01-l2-stp-etherchannel.md) | W1-3 | MST, LACP | 白紙から MST リージョン構築 |
| 02 | [OSPF](lab-02-ospf.md) | W4-7 | LSA, Area, Network Type | 隣接不成立の 5 原因を再現できる |
| 03 | [BGP](lab-03-bgp.md) | W8-10 | 経路選択順 | Weight/LocalPref で経路を動かせる |
| 04 | [FHRP / NAT](lab-04-fhrp-nat.md) | W11-12 | HSRP プリエンプト | 切替をリアルタイムで観測できる |
| 05 | [VRF / GRE / IPsec / Overlay](lab-05-vrf-gre-ipsec.md) | W13 | VRF-Lite, GRE | VRF 間で経路が分離されるのを確認 |
| 06 | [無線](lab-06-wireless.md) | W14 | CAPWAP, AP モード | 用語を図で説明できる |
| 07 | [セキュリティ / QoS](lab-07-security-qos.md) | W15-16 | ACL, CoPP, AAA | ACL で狙った通信だけ止められる |
| 08 | [自動化](lab-08-automation.md) | W17-18 | RESTCONF, Python | Python で hostname を変更できる |

---

## 毎日のタイムテーブル（平日 2h の例）

| 時間 | 内容 |
|------|------|
| 20 分 | Ping-t 30-40 問（新規 + 間違えた問題の復習） |
| 50 分 | ラボ（当該週のテーマ + 前週の「壊し方」再現） |
| 20 分 | ノート化（このリポジトリに追記 → commit） |
| 20 分 | 座学（無線 / アーキ / セキュリティの読み物） |
| 10 分 | 翌日の「白紙チャレンジ」お題を決める |

---

## 座学分野（コマンドが無い領域）の攻め方

無線・アーキテクチャ・仮想化の概念は、**ラボで手を動かせない＝定着しにくい**。
対策として **「自分で図を描いて .md に書く」** を必須にする。

| テーマ | 描く図 |
|--------|--------|
| SD-Access | Underlay / Overlay / Fabric Edge / Border / Control Plane(LISP) の関係 |
| SD-WAN | vManage / vSmart / vBond / vEdge の役割と通信方向 |
| 無線 | AP → CAPWAP → WLC → 有線 の経路と、Local/FlexConnect の違い |
| 仮想化 | ハイパーバイザ Type1/2、VRF、VXLAN の VNI とカプセル化 |
| QoS | 分類 → マーキング → キューイング → シェーピング/ポリシング の流れ |

> 「図が描けない ＝ 理解していない」と判定する。

---

## ENCOR 頻出の "引っかけ" 集

| 論点 | 引っかけどころ |
|------|----------------|
| STP | RSTP と MST の**ポート役割名は同じ**、違うのはインスタンス数 |
| EtherChannel | LACP は `active/passive`、PAgP は `desirable/auto`、**混在不可** |
| OSPF | Network Type が違うと Hello/Dead も変わり、隣接が上がらない |
| OSPF | **MTU 不一致は ExStart/Exchange で止まる**（Down にはならない） |
| BGP | iBGP は**スプリットホライズン**で再広告しない（RR が要る） |
| BGP | eBGP のデフォルト AD は 20、iBGP は 200 |
| HSRP | プリエンプトは**デフォルト無効**（VRRP はデフォルト有効） |
| NAT | `inside/outside` の向きを間違えると一切変換されない |
| QoS | ポリシング＝捨てる / シェーピング＝貯めて遅らせる |
| 自動化 | NETCONF=XML over SSH(830) / RESTCONF=JSON or XML over HTTPS(443) |

---

## 受験前の最終チェック（Week 19-20）

- [ ] Ping-t 模擬試験 90% 以上 × 3 回連続
- [ ] `commands/ccnp-command-cheatsheet.md` を**白紙から 8 割再現**できる
- [ ] lab-01 〜 lab-08 を**各 1 回、見ずに再構築**した
- [ ] 上の「引っかけ集」を全部説明できる
- [ ] 受験日を予約済み
