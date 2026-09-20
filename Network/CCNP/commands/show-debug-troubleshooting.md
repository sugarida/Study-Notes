# 障害切り分けフロー（show / debug の使い方）🩺
**用途：ENARSI 対策の中核 / 実務でもそのまま使える**

> 試験でも実務でも、**「下の層から順に潰す」** のが唯一の正解。
> 勘で debug を打つのではなく、**この順番で機械的に絞る。**

---

## 大原則：OSI 下位層から潰す

```
L1 : ケーブル・SFP・電源       → show interfaces / show power inline
L2 : VLAN・トランク・STP・MAC  → show interfaces trunk / show spanning-tree / show mac address-table
L3 : IP・ルーティング          → show ip interface brief / show ip route / ping / traceroute
L4 : ポート・ACL・NAT          → show access-lists / show ip nat translations
L7 : アプリ・DNS・認証         → telnet <host> <port> / show aaa servers
```

> 🔥 **L3 の問題に見えて L1/L2 が原因、というケースが最多。**
> 「ping が通らない」でいきなり `show ip route` を見るのは筋が悪い。

---

## Step 0：まず全体像を 3 コマンドで掴む

```cisco
show ip interface brief        ! IF と IP の一覧、up/down が一目で分かる
show ip route                  ! 経路の全体像
show ip protocols              ! 動いているルーティングプロトコルの全設定
```

`show ip interface brief` の読み方:
```
Interface        IP-Address      OK? Method Status              Protocol
Gi0/0            10.1.2.1        YES manual up                  up          ← 正常
Gi0/1            unassigned      YES unset  administratively down down      ← shutdown されている
Gi0/2            10.1.3.1        YES manual up                  down        ← L2 に問題（カプセル化/クロック/相手側）
Gi0/3            10.1.4.1        YES manual down                down        ← L1 に問題（ケーブル/SFP/相手shutdown）
```
| Status / Protocol | 意味 | 見るべき場所 |
|---|---|---|
| up / up | 正常 | — |
| administratively down / down | **`shutdown` されている** | `no shutdown` |
| **down / down** | **L1 障害** | ケーブル、SFP、相手側 |
| **up / down** | **L2 障害** | カプセル化不一致、クロック、キーリーブ |

---

## Step 1：L1 / L2 の切り分け

```cisco
show interfaces GigabitEthernet0/0
show interfaces status
show interfaces counters errors
show interfaces GigabitEthernet0/0 | include error|CRC|drops|duplex
show cdp neighbors detail
show lldp neighbors detail
show power inline
```

`show interfaces` で見るべき箇所:
```
GigabitEthernet0/0 is up, line protocol is up
  Hardware is ..., address is 0c11.2233.4400
  MTU 1500 bytes, BW 1000000 Kbit/sec, DLY 10 usec,
  Full Duplex, 1000Mbps, link type is auto
     0 input errors, 0 CRC, 0 frame, 0 overrun, 0 ignored    ← ★ここ
     0 output errors, 0 collisions, 0 interface resets
```
| 症状 | 原因 |
|------|------|
| **CRC エラーが増える** | ケーブル不良、SFP 不良、**デュプレックス不一致** |
| **collisions（全二重なのに）** | **デュプレックス不一致** |
| **input drops / overrun** | 輻輳、CPU 過負荷 |
| **interface resets** | 物理リンクのフラップ |
| MTU が左右で違う | **OSPF の隣接が ExStart で止まる** |

### L2 疎通の確認
```cisco
show vlan brief
show interfaces trunk
show mac address-table [interface Gi0/10 | vlan 10 | address 0011.2233.4455]
show spanning-tree vlan 10
show spanning-tree blockedports
show etherchannel summary
```

---

## Step 2：L3 の切り分け

```cisco
! 経路があるか
show ip route
show ip route 192.168.10.0
show ip route 192.168.10.5          ! ロンゲストマッチの結果が見られる
show ip cef 192.168.10.5            ! 実際の転送経路
```

`show ip route <prefix>` の読み方:
```
Routing entry for 192.168.10.0/24
  Known via "ospf 1", distance 110, metric 20, type extern 2
  Last update from 10.1.2.2 on GigabitEthernet0/0, 00:05:12 ago
  Routing Descriptor Blocks:
  * 10.1.2.2, from 2.2.2.2, 00:05:12 ago, via GigabitEthernet0/0
      Route metric is 20, traffic share count is 1
```
- `distance 110` → AD。複数プロトコルで競合していないか
- `type extern 2` → 再配送された外部経路
- `Last update` → いつから変わっていないか（フラップしていないか）

### ping / traceroute の使い分け
```cisco
! 基本
ping 192.168.10.5
! 送信元を指定（ルーティングの戻りを確認する時に必須）
ping 192.168.10.5 source Loopback0
! 拡張 ping（MTU / DF ビットの検証）
ping 192.168.10.5 size 1500 df-bit repeat 100
! 経路の確認
traceroute 192.168.10.5 source Loopback0
```

> 🔥 **「行きは通るが帰りが無い」が片方向障害の正体。**
> `ping <相手> source <自分のLoopback>` で失敗するなら、**相手側に自分の Loopback への経路が無い**。

### VRF 環境では
```cisco
show ip route vrf CUST_A
ping vrf CUST_A 192.168.10.5
traceroute vrf CUST_A 192.168.10.5
```

---

## Step 3：ルーティングプロトコル別の切り分け

### OSPF
```cisco
show ip ospf neighbor                 ! FULL か？
show ip ospf interface Gi0/0          ! Area / Timer / Network Type / MTU / Cost / Passive
show ip ospf database
show ip protocols
debug ip ospf adj
```
| 症状 | 原因の候補 |
|------|-----------|
| ネイバーが**表示されない** | Area 不一致 / Timer 不一致 / Network Type 不一致 / passive-interface / ACL / サブネット不一致 |
| **ExStart / Exchange で止まる** | **MTU 不一致** |
| **2-Way で止まる** | DROther 同士なら正常。P2P なら Priority を疑う |
| 隣接はあるが経路が来ない | エリア種別（Stub で Type5 遮断）/ フィルタ / 集約 |
| フラップする | 物理リンク不安定 / Router-ID 重複 / タイマが短すぎる |

### EIGRP
```cisco
show ip eigrp neighbors
show ip eigrp topology
show ip eigrp interfaces detail
show ip protocols
debug eigrp packets
```
| 症状 | 原因 |
|------|------|
| ネイバーにならない | **AS 番号不一致 / K値不一致 / 認証不一致 / network 文漏れ / passive-interface** |
| SIA（Stuck In Active） | Query が広がりすぎ → **Stub / 集約で Query 範囲を絞る** |
| 冗長経路が使われない | FS の条件（RD < FD）を満たしていない → `variance` |

### BGP
```cisco
show ip bgp summary                   ! State/PfxRcd が数字か？
show ip bgp neighbors 10.1.2.2
show ip bgp <prefix>                  ! (inaccessible) が無いか
show ip bgp neighbors x received-routes
debug ip bgp
```
| 症状 | 原因 |
|------|------|
| `Idle` | TCP 179 が張れない（到達性 / ACL / shutdown） |
| `Active` | **接続試行中＝確立できていない**（AS 番号ミス / update-source / ebgp-multihop） |
| 経路は見えるが `>` が付かない | **Next-Hop 到達不能**（`next-hop-self` 漏れ） |
| iBGP 先に経路が来ない | **iBGP スプリットホライズン**（RR / フルメッシュ） |
| 一部経路だけ来ない | route-map の暗黙 deny / prefix-list / filter-list |

---

## Step 4：ACL / NAT / セキュリティ

```cisco
show access-lists                     ! ★マッチ数を見る
show ip interface Gi0/0 | include access list
show ip nat translations
show ip nat statistics                ! Hits / Misses
show port-security interface Gi0/10
show interfaces status err-disabled
show ip dhcp snooping binding
```

### 切り分けの考え方
```
① 通らない → ACL の deny 行のカウンタは増えているか？
     増えている  → ACL が原因。permit 行を追加
     増えていない → そもそも ACL を通っていない（適用先/方向ミス）or 別の原因
② NAT が効かない → show ip nat statistics の Hits が増えるか？
     増えない → ip nat inside/outside の付け忘れ or 向き間違い or ACL ミス
```

---

## Step 5：debug の作法

```cisco
! 1) 必ず時刻を付ける
service timestamps debug datetime msec

! 2) リモート接続なら必須
terminal monitor

! 3) 対象を絞る（ACL で絞るのが安全）
access-list 100 permit icmp host 192.168.10.5 any
debug ip packet 100 detail

! 4) 今何が動いているか確認
show debugging

! 5) 必ず止める
undebug all
! または
no debug ip packet
```

### ⚠️ debug の危険度
| コマンド | 危険度 | 備考 |
|---------|--------|------|
| `debug ip ospf adj` | 低 | 隣接確立時のみ出力 |
| `debug ip bgp` | 中 | 経路数が多いと大量出力 |
| `debug ip packet` | **高** | **ACL で絞らないと機器が落ちる**。プロセススイッチングを強制する |
| `debug all` | **最高** | **絶対に打たない** |

> 🔥 **本番機で `debug ip packet` を絞らずに打つのは事故。**
> 代わりに **Embedded Packet Capture** や **SPAN** を使う。

### Embedded Packet Capture（debug の代替）
```cisco
ip access-list extended CAP-ACL
 permit ip host 192.168.10.5 any
!
monitor capture CAP interface GigabitEthernet0/0 both
monitor capture CAP access-list CAP-ACL
monitor capture CAP buffer size 10
monitor capture CAP start
! ... しばらく待つ ...
monitor capture CAP stop
show monitor capture CAP buffer brief
show monitor capture CAP buffer dump
monitor capture CAP export flash:cap.pcap
```

### SPAN（ミラーリング）
```cisco
monitor session 1 source interface GigabitEthernet0/1 both
monitor session 1 destination interface GigabitEthernet0/24
show monitor session 1
```

---

## Step 6：ログと時刻

```cisco
show logging
show logging | include %OSPF|%BGP|%LINK
show clock
show ntp status
show ntp associations
```

### ログレベル（0 が最重要）
| Level | 名称 | 例 |
|-------|------|-----|
| 0 | Emergency | システム使用不能 |
| 1 | Alert | 即対応 |
| 2 | Critical | 重大 |
| **3** | **Error** | インターフェースエラー |
| **4** | **Warning** | 設定の警告 |
| **5** | **Notification** | **リンク up/down はここ** |
| 6 | Informational | 情報 |
| 7 | Debugging | debug 出力 |

```cisco
logging trap informational      ! 6 以下を Syslog サーバへ
logging buffered 32768 debugging
logging console warnings        ! コンソールを静かにする
```

> 📌 **`show logging` を最初に見る習慣をつける。**
> 「いつ壊れたか」「どこが壊れたか」がログに全部書いてあることが多い。

---

## 切り分けチートシート（1 枚版）

| 症状 | 最初に打つ 3 コマンド |
|------|---------------------|
| IF が上がらない | `show ip int brief` / `show interfaces Gi0/0` / `show cdp neighbors` |
| 同一 VLAN 内で通信できない | `show vlan brief` / `show interfaces trunk` / `show mac address-table` |
| 別ネットワークへ通信できない | `show ip route` / `ping source` / `traceroute` |
| OSPF が上がらない | `show ip ospf neighbor` / `show ip ospf interface` / `debug ip ospf adj` |
| EIGRP が上がらない | `show ip eigrp neighbors` / `show ip protocols` / `show ip eigrp interfaces` |
| BGP が上がらない | `show ip bgp summary` / `show ip bgp neighbors` / `debug ip bgp` |
| 経路はあるが通らない | `show access-lists` / `show ip nat statistics` / `show ip cef <dst>` |
| 冗長構成が切り替わらない | `show standby brief` / `show track` / `show ip sla statistics` |
| 遅い・切れる | `show interfaces counters errors` / `show policy-map interface` / `show processes cpu sorted` |
| 原因が分からない | `show logging` / `show clock` / `show tech-support`（最終手段） |

---

## 🔥 ENARSI 対策の使い方

1. 各ラボを正しく組む → コンフィグを保存
2. **3 か所わざと壊す**（壊した内容は別ファイルにメモして、見ない）
3. 1 週間後に読み込み、**この切り分けフローだけを使って直す**
4. かかった時間を `progress/` に記録
5. **平均 15 分以内**で直せるようになったら Lv.3 到達
