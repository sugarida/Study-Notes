# Lab 02：OSPF（v2 / v3）🌐
**対象週：Week 4-7 / ENCOR の最重要ラボ**

> ENCOR/ENARSI 両方で配点が大きく、**ラボで確実に点を取れる**分野。
> ここに一番時間をかけてよい。

---

## トポロジ

```
        Area 1              Area 0              Area 2(NSSA)
   [R5]------[R1]--------[R2]--------[R3]--------[R4]
             |                        |
          Lo0 1.1.1.1              Lo0 3.3.3.3
```
- R1-R2、R2-R3：Area 0（バックボーン）
- R1-R5：Area 1
- R3-R4：Area 2（NSSA として構成）

---

## Step 1：基本設定（OSPFv2）

```cisco
! --- R1 ---
interface Loopback0
 ip address 1.1.1.1 255.255.255.255
 ip ospf 1 area 0
!
interface GigabitEthernet0/0
 description to R2
 ip address 10.1.2.1 255.255.255.252
 ip ospf 1 area 0
 ip ospf network point-to-point
!
interface GigabitEthernet0/1
 description to R5
 ip address 10.1.5.1 255.255.255.252
 ip ospf 1 area 1
!
router ospf 1
 router-id 1.1.1.1
 passive-interface Loopback0
 auto-cost reference-bandwidth 100000
```

### 2 つの書き方（どちらも出題される）
```cisco
! 方式A：インターフェース配下（新しい・推奨）
interface GigabitEthernet0/0
 ip ospf 1 area 0

! 方式B：router 配下の network 文（伝統的）
router ospf 1
 network 10.1.2.0 0.0.0.3 area 0
 network 1.1.1.1 0.0.0.0 area 0
```
> 📌 `network` 文のマスクは **ワイルドカードマスク**（サブネットマスクの逆）。
> `255.255.255.252` → `0.0.0.3`、`255.255.255.0` → `0.0.0.255`。

### reference-bandwidth の注意
```cisco
router ospf 1
 auto-cost reference-bandwidth 100000   ! 単位 Mbps → 100Gbps基準
```
> デフォルトは 100Mbps 基準のため、**1G も 10G も コスト 1** になってしまう。
> **全ルータで同じ値に揃えること**（揃えないと経路計算が歪む）。

---

## Step 2：隣接確認（ここを読めるようにする）

```cisco
show ip ospf neighbor
show ip ospf interface brief
show ip ospf interface GigabitEthernet0/0
show ip ospf database
show ip route ospf
```

`show ip ospf neighbor`:
```
Neighbor ID     Pri   State           Dead Time   Address         Interface
2.2.2.2           0   FULL/  -        00:00:35    10.1.2.2        GigabitEthernet0/0
```
| State | 意味 | この状態で止まる原因 |
|-------|------|---------------------|
| Down | Hello を受け取っていない | 物理/passive-interface/ACL |
| Init | 片方向だけ Hello 受信 | 相手が自分を認識していない |
| 2-Way | 双方向確立（DR/BDR 選出済） | **DROther 同士は 2-Way で正常** |
| ExStart | DBD 交換開始 | **MTU 不一致** |
| Exchange | DBD 交換中 | **MTU 不一致** |
| Loading | LSR/LSU でデータ要求中 | — |
| **FULL** | 完全同期 = 正常 | — |

`show ip ospf interface Gi0/0` の見るべき行:
```
GigabitEthernet0/0 is up, line protocol is up
  Internet Address 10.1.2.1/30, Area 0
  Process ID 1, Router ID 1.1.1.1, Network Type POINT_TO_POINT, Cost: 1
  Timer intervals configured, Hello 10, Dead 40, Wait 40, Retransmit 5
  Neighbor Count is 1, Adjacent neighbor count is 1
```

---

## Step 3：Network Type（出題頻出）

| Network Type | Hello/Dead | DR/BDR | 手動ネイバー | 典型的な用途 |
|--------------|------------|--------|--------------|--------------|
| **Broadcast** | 10 / 40 | あり | 不要 | Ethernet（デフォルト） |
| **Point-to-Point** | 10 / 40 | **なし** | 不要 | シリアル、P2P リンク |
| **Non-Broadcast (NBMA)** | **30 / 120** | あり | **必要** | Frame Relay |
| **Point-to-Multipoint** | **30 / 120** | なし | 不要 | ハブ&スポーク |
| Point-to-Multipoint Non-Broadcast | 30 / 120 | なし | 必要 | 特殊 |

```cisco
interface GigabitEthernet0/0
 ip ospf network point-to-point
```

> 🔥 **Network Type が違うと Hello/Dead も変わるため隣接が上がらない。**
> Broadcast(10/40) と Point-to-Multipoint(30/120) を対向させると Down のまま。
> 「隣接が上がらない → まず `show ip ospf interface` で Network Type と Timer を両側比較」。

### タイマを手動で合わせる場合
```cisco
interface GigabitEthernet0/0
 ip ospf hello-interval 10
 ip ospf dead-interval 40
```

### DR/BDR 選出（Broadcast/NBMA のみ）
```
1. OSPF Priority が最大（0 は選出対象外 = DROther 固定）
2. 同値なら Router-ID が最大
※ 先に選ばれた DR は、より優秀なルータが来ても "奪われない"（非プリエンプト）
```
```cisco
interface GigabitEthernet0/0
 ip ospf priority 255    ! DR にしたい
 ip ospf priority 0      ! 絶対に DR にしない
! 反映には OSPF プロセスの再起動が必要
clear ip ospf process
```

---

## Step 4：LSA タイプ（暗記必須）

| Type | 名称 | 生成元 | 伝播範囲 |
|------|------|--------|----------|
| **1** | Router LSA | 全ルータ | **同一エリア内のみ** |
| **2** | Network LSA | **DR** | 同一エリア内のみ |
| **3** | Summary LSA | **ABR** | 他エリアへ（エリア間経路） |
| **4** | ASBR Summary | ABR | ASBR の位置を他エリアへ通知 |
| **5** | AS External | **ASBR** | **全エリア（Stub/NSSA を除く）** |
| **7** | NSSA External | NSSA 内の ASBR | **NSSA 内のみ**（ABR で Type5 に変換） |

```cisco
show ip ospf database
show ip ospf database router
show ip ospf database network
show ip ospf database summary
show ip ospf database external
show ip ospf database nssa-external
```

### ルートコードの対応
```cisco
show ip route ospf
```
```
O        192.168.5.0/24 [110/2] via 10.1.5.2        ← エリア内（Type1/2）
O IA     192.168.3.0/24 [110/3] via 10.1.2.2        ← エリア間（Type3）
O E2     172.16.0.0/16  [110/20] via 10.1.2.2       ← 外部 Type2（コスト固定）
O E1     172.17.0.0/16  [110/84] via 10.1.2.2       ← 外部 Type1（コスト加算）
O N2     10.99.0.0/16   [110/20] via 10.1.2.2       ← NSSA 外部
```
> 📌 **E2 は再配送時のコストのまま変わらない（デフォルト）。E1 は内部コストを足していく。**

---

## Step 5：エリア種別

```cisco
! --- Stub Area（Type5 を遮断、デフォルトルートを注入）---
! エリア内の全ルータ（ABR含む）で設定
router ospf 1
 area 1 stub

! --- Totally Stubby（Type3,4,5 を遮断）---
! ABR のみ no-summary を付ける
router ospf 1
 area 1 stub no-summary

! --- NSSA（Type7 を許可、Type5 は遮断）---
router ospf 1
 area 2 nssa

! --- Totally NSSA ---
router ospf 1
 area 2 nssa no-summary

! --- NSSA にデフォルトルートを注入 ---
router ospf 1
 area 2 nssa default-information-originate
```

| エリア種別 | Type3 | Type4/5 | Type7 | デフォルトルート |
|-----------|-------|---------|-------|------------------|
| 通常 | ○ | ○ | × | — |
| Stub | ○ | **×** | × | ABR が注入 |
| Totally Stubby | **×** | **×** | × | ABR が注入 |
| NSSA | ○ | **×** | **○** | 任意 |
| Totally NSSA | **×** | **×** | ○ | ABR が注入 |

> 🔥 **Stub 設定はエリア内の全ルータで一致していないと隣接が上がらない**（Hello 内の E ビット不一致）。
> `no-summary` だけは ABR のみでよい。

---

## Step 6：集約（サマリ）

```cisco
! --- ABR で エリア間経路を集約（Type3 を束ねる）---
router ospf 1
 area 1 range 192.168.0.0 255.255.252.0

! --- ASBR で 外部経路を集約（Type5 を束ねる）---
router ospf 1
 summary-address 172.16.0.0 255.255.0.0
```
> 📌 **`area range` は ABR 専用、`summary-address` は ASBR 専用。** 場所を間違えると効かない。

---

## Step 7：認証

```cisco
! --- インターフェース単位（推奨）---
interface GigabitEthernet0/0
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 CcnpLab123

! --- エリア単位 ---
router ospf 1
 area 0 authentication message-digest

! --- 確認 ---
show ip ospf interface GigabitEthernet0/0 | include authentication|Message
```
> 認証不一致は隣接が上がらず、`debug ip ospf adj` に mismatch が出る。

---

## Step 8：デフォルトルートの注入

```cisco
ip route 0.0.0.0 0.0.0.0 203.0.113.1
!
router ospf 1
 default-information originate
! 自分にデフォルトルートが無くても流したい場合
 default-information originate always
```

---

## Step 9：OSPFv3（IPv6）

```cisco
ipv6 unicast-routing
!
interface GigabitEthernet0/0
 ipv6 address 2001:DB8:1:2::1/64
 ipv6 ospf 1 area 0
!
ipv6 router ospf 1
 router-id 1.1.1.1
```
```cisco
show ipv6 ospf neighbor
show ipv6 ospf interface brief
show ipv6 route ospf
```
> 📌 **OSPFv3 でも Router-ID は 32bit（IPv4 形式）。IPv6 アドレスが無いと自動生成できず起動しない**ので、
> `router-id` を明示するのが鉄則。

---

## 🔨 わざと壊す（隣接が上がらない 5 大原因）

**これを 5 回再現した人だけが、試験で即答できる。**

| # | 壊し方 | 症状 | 検出コマンド |
|---|--------|------|--------------|
| 1 | 片側の `area` を 1 に変える | Down のまま | `show ip ospf interface` の Area 行を両側比較 |
| 2 | 片側の `hello-interval` を 30 に | Down のまま | `show ip ospf interface` の Timer 行 |
| 3 | 片側の `ip mtu 1400` | **ExStart/Exchange で停止** | `show ip ospf neighbor`, `debug ip ospf adj` |
| 4 | 片側だけ認証キーを変える | Down、認証エラーログ | `debug ip ospf adj`, `show log` |
| 5 | 片側の Network Type を変える | Down（タイマも不一致に） | `show ip ospf interface` |
| 6 | 両側の Router-ID を重複させる | 隣接が不安定・ログに duplicate | `show ip ospf`, `show log` |
| 7 | `passive-interface Gi0/0` を入れる | Hello が出ず Down | `show ip ospf interface` が Passive 表示 |

### MTU 不一致の切り分け（ENARSI でも頻出）
```cisco
! 症状：ExStart / Exchange から進まない
show ip ospf neighbor
! → State が ExStart のまま

show interfaces GigabitEthernet0/0 | include MTU
show ip ospf interface GigabitEthernet0/0 | include MTU

! 暫定回避（MTU チェックを無視する ※根本対処ではない）
interface GigabitEthernet0/0
 ip ospf mtu-ignore
```

### debug の使い方（必ず時刻を付けてから）
```cisco
service timestamps debug datetime msec
terminal monitor              ! SSH/Telnet の場合は必須
debug ip ospf adj
debug ip ospf hello
!
undebug all                   ! 止めるのを忘れない
show debugging
```
> ⚠️ **debug は CPU を食う。本番機では `debug ip ospf adj` 程度でも慎重に。**
> ラボでは遠慮なく回してよい。

---

## ✅ 卒業条件

- [ ] 白紙から 3 エリア構成を 10 分で構築できる
- [ ] LSA タイプ 1/2/3/4/5/7 を**表で書き出せる**
- [ ] エリア種別と遮断される LSA の表を**書き出せる**
- [ ] Network Type ごとの Hello/Dead/DR を**言える**
- [ ] 上の「壊し方」7 パターンを全部再現し、show で特定できた
- [ ] `O` / `O IA` / `O E1` / `O E2` / `O N2` を見分けられる
