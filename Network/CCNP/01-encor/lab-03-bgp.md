# Lab 03：BGP 🌍
**対象週：Week 8-10**

> OSPF が「最短経路を計算する」のに対し、BGP は **「ポリシーで経路を選ぶ」**。
> 試験では **ネイバー確立条件** と **経路選択順** の 2 点に集約される。

---

## トポロジ

```
   AS 65001                AS 65002               AS 65003
  [R1]---eBGP---[R2]===iBGP===[R3]---eBGP---[R4]
 Lo0 1.1.1.1   Lo0 2.2.2.2  Lo0 3.3.3.3   Lo0 4.4.4.4
```

---

## Step 1：eBGP ピアリング

```cisco
! --- R1 (AS 65001) ---
router bgp 65001
 bgp router-id 1.1.1.1
 bgp log-neighbor-changes
 neighbor 10.1.2.2 remote-as 65002
 neighbor 10.1.2.2 description to-R2-eBGP
 !
 address-family ipv4 unicast
  neighbor 10.1.2.2 activate
  network 192.168.1.0 mask 255.255.255.0
 exit-address-family

! --- R2 (AS 65002) ---
router bgp 65002
 bgp router-id 2.2.2.2
 neighbor 10.1.2.1 remote-as 65001
 neighbor 3.3.3.3 remote-as 65002        ! iBGP（Loopback ピア）
 neighbor 3.3.3.3 update-source Loopback0
 !
 address-family ipv4 unicast
  neighbor 10.1.2.1 activate
  neighbor 3.3.3.3 activate
  neighbor 3.3.3.3 next-hop-self
 exit-address-family
```

> 📌 `network` 文は「広告したい経路が **すでにルーティングテーブルに存在する**」ことが条件。
> マスクも完全一致でないと広告されない（`network 192.168.1.0 mask 255.255.255.0`）。

### eBGP と iBGP の違い（超頻出）

| | eBGP | iBGP |
|---|------|------|
| 相手 AS | 異なる | 同じ |
| AD（管理距離） | **20** | **200** |
| TTL | **1**（直結前提） | 255 |
| 受信経路の再広告 | 他の eBGP/iBGP へ広告する | **他の iBGP へは広告しない**（スプリットホライズン） |
| Next-Hop | 自分に書き換わる | **書き換わらない** → `next-hop-self` が要る |
| ピア先 | 直結 IF が基本 | Loopback 推奨（冗長経路で生存） |

### Loopback ピアに必要な設定
```cisco
! iBGP：Loopback へ到達する経路が IGP に必要
neighbor 3.3.3.3 update-source Loopback0

! eBGP で Loopback ピアする場合は TTL を伸ばす（デフォルト TTL=1 のため）
neighbor 4.4.4.4 ebgp-multihop 2
neighbor 4.4.4.4 update-source Loopback0
```

---

## Step 2：確認コマンド

```cisco
show ip bgp summary
show ip bgp
show ip bgp neighbors
show ip bgp neighbors 10.1.2.2 advertised-routes
show ip bgp neighbors 10.1.2.2 received-routes   ! soft-reconfiguration inbound が必要
show ip bgp neighbors 10.1.2.2 routes
show ip route bgp
```

`show ip bgp summary` の読み方:
```
Neighbor    V    AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.1.2.2    4 65002      42      45        8    0    0 00:35:12        3
3.3.3.3     4 65002      12      14        8    0    0 00:10:03        0
```
| State/PfxRcd の値 | 意味 |
|------|------|
| **数字**（例 `3`） | **確立済み(Established)。受信プレフィックス数** |
| `Idle` | 開始前 or 障害。**TCP 179 が張れていない** |
| `Active` | 接続試行中。**到達性 or AS 番号ミスを疑う** |
| `Idle (Admin)` | `neighbor x shutdown` されている |
| `OpenSent`/`OpenConfirm` | ネゴシエーション途中 |

> 🔥 **`Active` は「活発」ではなく「接続できていない」。** ここは必ず引っかけで出る。

`show ip bgp` の読み方:
```
   Network          Next Hop         Metric LocPrf Weight Path
*>  192.168.1.0     10.1.2.1              0             0 65001 i
*   192.168.4.0     10.1.2.2                            0 65002 65003 i
*>i 192.168.4.0     3.3.3.3               0    100      0 65003 i
```
| 記号 | 意味 |
|------|------|
| `*` | valid（有効な経路） |
| `>` | **best（ベストパス。これがルーティングテーブルに入る）** |
| `i`（先頭） | iBGP から学習 |
| `i`（末尾） | Origin = IGP |
| `e`（末尾） | Origin = EGP |
| `?`（末尾） | Origin = incomplete（再配送由来） |

---

## Step 3：経路選択順（BGP Best Path Selection）🔥

**BGP で一番出題される。呪文として暗記する。**

```
0. Next-Hop に到達できること（到達不能なら候補外）
1. Weight        最大   （Cisco独自・ローカルのみ・デフォルト0、自分発は32768）
2. Local Preference 最大（AS 内で共有・デフォルト100）
3. 自分が発信した経路（network / redistribute / aggregate）
4. AS_PATH       最短
5. Origin        IGP(i) < EGP(e) < Incomplete(?)
6. MED           最小  （隣接 AS へ「入口」を伝える・デフォルト0）
7. eBGP > iBGP
8. IGP メトリック 最小（Next-Hop までのコスト）
9. 古い eBGP 経路を優先（安定性）
10. Router-ID   最小
11. ピアアドレス 最小
```

### 語呂（好きな方で）
```
We  Love  Oranges  AS  Oranges  Mean  Pure  Refreshment
Weight / LocalPref / Originate / AS_PATH / Origin / MED / Paths(eBGP>iBGP) / RID
```

### 属性のスコープ（これも頻出）
| 属性 | 種別 | 伝播範囲 |
|------|------|----------|
| **Weight** | Cisco 独自 | **そのルータ内だけ**（広告されない） |
| **Local Preference** | Well-known discretionary | **自 AS 内のみ**（iBGP で伝播） |
| **AS_PATH** | Well-known mandatory | 全体 |
| **Origin** | Well-known mandatory | 全体 |
| **MED** | Optional non-transitive | **隣接 AS まで**（その先へは伝播しない） |
| **Next-Hop** | Well-known mandatory | 全体 |
| Community | Optional transitive | 全体（設定で伝播制御） |

> 📌 **Local Preference = 自 AS からの「出口」を決める（outbound）**
> **MED = 隣接 AS からの「入口」を決める（inbound）**
> この方向の違いが問われる。

---

## Step 4：経路操作（ポリシー）

### Weight（ローカル優先）
```cisco
router bgp 65001
 neighbor 10.1.2.2 weight 200
```
または route-map で:
```cisco
route-map SET-WEIGHT permit 10
 set weight 200
!
router bgp 65001
 address-family ipv4
  neighbor 10.1.2.2 route-map SET-WEIGHT in
```

### Local Preference
```cisco
ip prefix-list PFX-NET4 seq 5 permit 192.168.4.0/24
!
route-map SET-LP permit 10
 match ip address prefix-list PFX-NET4
 set local-preference 200
route-map SET-LP permit 20          ! ← 暗黙の deny 対策。忘れると他が全部落ちる
!
router bgp 65002
 address-family ipv4
  neighbor 10.1.2.1 route-map SET-LP in
```
> 🔥 **route-map の最後には暗黙の `deny any` がある。** 「permit 20」を書き忘れると
> マッチしない経路が全部捨てられる。ENARSI の定番トラップ。

### AS_PATH Prepend（自 AS への流入を減らす）
```cisco
route-map PREPEND permit 10
 set as-path prepend 65001 65001 65001
!
router bgp 65001
 address-family ipv4
  neighbor 10.1.2.2 route-map PREPEND out
```

### MED
```cisco
route-map SET-MED permit 10
 set metric 50
!
 neighbor 10.1.2.2 route-map SET-MED out
```

### フィルタリング（3 通り）
```cisco
! 1) prefix-list
ip prefix-list ONLY-NET1 seq 5 permit 192.168.1.0/24
 neighbor 10.1.2.2 prefix-list ONLY-NET1 out

! 2) AS-PATH ACL（正規表現）
ip as-path access-list 1 permit ^65001$      ! 直接接続のAS 65001発のみ
ip as-path access-list 1 permit ^$           ! 自AS発のみ
 neighbor 10.1.2.2 filter-list 1 out

! 3) route-map（上記の組み合わせ + 属性変更）
 neighbor 10.1.2.2 route-map POLICY in
```

### 設定変更の反映（クリア方法）
```cisco
! ソフトリセット（推奨。セッションを切らない）
clear ip bgp 10.1.2.2 soft in
clear ip bgp 10.1.2.2 soft out
clear ip bgp * soft

! ハードリセット（セッション断。本番では厳禁レベル）
clear ip bgp *

! received-routes を見るために必要
router bgp 65002
 address-family ipv4
  neighbor 10.1.2.1 soft-reconfiguration inbound
```

---

## Step 5：iBGP フルメッシュ問題と Route Reflector

```
iBGP はスプリットホライズンにより、iBGP で学んだ経路を他の iBGP へ広告しない
→ AS 内の全ルータ同士をフルメッシュで張る必要がある（n(n-1)/2 本）
→ 解決策：Route Reflector または Confederation
```

```cisco
! --- RR（R2 をリフレクタにする）---
router bgp 65002
 address-family ipv4
  neighbor 3.3.3.3 route-reflector-client
  neighbor 5.5.5.5 route-reflector-client
```
```cisco
show ip bgp neighbors 3.3.3.3 | include Route-Reflector
show ip bgp 192.168.4.0
```

---

## Step 6：集約

```cisco
router bgp 65001
 address-family ipv4
  ! 詳細経路も一緒に広告
  aggregate-address 192.168.0.0 255.255.252.0
  ! 集約経路だけ広告（詳細を抑制）
  aggregate-address 192.168.0.0 255.255.252.0 summary-only
```

---

## 🔨 わざと壊す

| # | 壊し方 | 症状 | 確認 |
|---|--------|------|------|
| 1 | `remote-as` を間違える | `Active` / `Idle` を往復 | `show ip bgp summary`, `debug ip bgp` |
| 2 | Loopback ピアで `update-source` を消す | セッションが張れない | `show ip bgp neighbors \| include Local host` |
| 3 | eBGP の Loopback ピアで `ebgp-multihop` を消す | TTL 切れで確立しない | `debug ip bgp` |
| 4 | iBGP で `next-hop-self` を消す | 経路は見えるが **`>` が付かない**（到達不能） | `show ip bgp`（Next Hop 欄を見る） |
| 5 | route-map の最後の `permit` を消す | 一部経路が消える | `show ip bgp neighbors x received-routes` |
| 6 | `network` のマスクを間違える | 広告されない | `show ip bgp`, `show ip route` |
| 7 | iBGP フルメッシュを崩す | 一部ルータに経路が来ない | `show ip bgp` を全台で比較 |

### 「経路は見えるのに使われない」ときの切り分け
```cisco
show ip bgp 192.168.4.0/24
```
```
  Refresh Epoch 1
  65003
    3.3.3.3 (inaccessible) from 3.3.3.3 (3.3.3.3)   ← ★ Next-Hop に届いていない
      Origin IGP, metric 0, localpref 100, valid, internal
```
> `(inaccessible)` が出たら **Next-Hop への IGP 経路が無い**。
> `next-hop-self` を入れるか、IGP にリンクを載せる。

---

## ✅ 卒業条件

- [ ] eBGP / iBGP を白紙から 10 分で構築できる
- [ ] **経路選択順を 1 番から 11 番まで書き出せる**
- [ ] `Active` / `Idle` / 数字 の違いを説明できる
- [ ] Weight・LocalPref・MED・AS_PATH prepend で**実際に経路を動かせた**
- [ ] LocalPref（出口）と MED（入口）の方向の違いを説明できる
- [ ] 上の「壊し方」7 パターンを再現した
