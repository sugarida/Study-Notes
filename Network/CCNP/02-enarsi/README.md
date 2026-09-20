# ENARSI 300-410 学習ガイド 🔧
**対象週：Week 21-32 / ENCOR 合格後に着手**

> ENCOR が「広く浅く」なら、ENARSI は **「狭く深く、そして壊れたものを直す」**。
> 試験の性格が違うので、**勉強法も変える**必要がある。

---

## ENCOR との違い

| | ENCOR | ENARSI |
|---|-------|--------|
| 範囲 | 広い（無線・自動化・アーキも） | **ルーティングとサービスに集中** |
| 深さ | 浅い | **深い（LSA 単位・属性単位）** |
| 問われ方 | 「正しい設定はどれか」 | **「この出力から原因を特定せよ」** |
| 必要レベル | Lv.2（白紙から打てる） | **Lv.3（show から原因を言い当てる）** |

### 出題比率（計画用の目安。必ず公式 Exam Topics で確認）
| 分野 | 比率 |
|------|------|
| Layer 3 Technologies（EIGRP / OSPF / BGP / 再配送） | **約 35%** |
| VPN Technologies（MPLS / DMVPN） | 約 20% |
| Infrastructure Security | 約 20% |
| Infrastructure Services（SNMP / Syslog / NetFlow / IP SLA 等） | 約 25% |

---

## 学習方針：「壊れたラボ」を作る

ENARSI の本質はトラブルシュート。そこで**学習方法を反転させる**。

```
ENCOR まで : 正しく組む → 動くことを確認する
ENARSI     : 正しく組む → 保存する → わざと壊す → "翌週の自分"が直す
```

### 具体的な回し方
1. 週の前半：テーマのラボを正しく組み、コンフィグを保存（`show run` をこのリポジトリへ）
2. **わざと 3 か所壊して、別名で保存**（どこを壊したかは別ファイルにメモして見ない）
3. 週の後半（または翌週）：壊したコンフィグを読み込み、**時間を計って直す**
4. 直せなかったら、その論点を .md に追記

> 💡 「自分で仕込んだ不具合を 1 週間後に忘れている」ことを利用する。これが独学での擬似トラブルシュート演習。

---

## ラボ課題一覧

### 1. EIGRP（Week 21-22）
```cisco
router eigrp CCNP-LAB
 address-family ipv4 unicast autonomous-system 100
  network 10.0.0.0 0.255.255.255
  af-interface GigabitEthernet0/0
   no passive-interface
   authentication mode md5
   hello-interval 5
   hold-time 15
  exit-af-interface
  eigrp router-id 1.1.1.1
  eigrp stub connected summary
 exit-address-family
```
```cisco
show ip eigrp neighbors
show ip eigrp topology
show ip eigrp topology all-links
show ip eigrp interfaces detail
show ip protocols
debug eigrp packets
```
**押さえる論点**
- **DUAL**：Successor / Feasible Successor / FD / RD（Advertised Distance）
- **Feasibility Condition：RD < FD**（これを満たすものだけが FS）
- メトリック：帯域幅 + 遅延（デフォルトで K1=1, K3=1、K2/K4/K5=0）
- **K値が不一致だと隣接が上がらない**
- 隣接が上がらない原因：**AS 番号不一致 / K値不一致 / 認証不一致 / ネットワーク文漏れ / passive-interface**
- Stub ルータは Query を受けない → **SIA（Stuck In Active）対策**
- 不等コストロードバランス：`variance <倍数>`

### 2. OSPF 深堀り（Week 23-24）
`../01-encor/lab-02-ospf.md` の内容 + 以下
- 仮想リンク（Virtual Link）：Area 0 に接続していないエリアの救済
```cisco
router ospf 1
 area 1 virtual-link 3.3.3.3
```
- LSA の Sequence / Age / Checksum を `show ip ospf database` で読む
- SPF 計算のタイマ調整（`timers throttle spf`）
- Sham Link（MPLS VPN 環境）

### 3. BGP 深堀り（Week 25-26）
`../01-encor/lab-03-bgp.md` の内容 + 以下
- Community（`send-community`、no-export / no-advertise / local-AS）
```cisco
ip community-list standard CM1 permit 65001:100
route-map SET-COMM permit 10
 set community 65001:100
!
 neighbor 10.1.2.2 send-community
```
- Route Reflector のクラスタ構成、Confederation
- `bgp dampening`（経路のフラップ抑制）
- **MP-BGP（VPNv4）と RD / RT**
- `maximum-prefix`、`bgp allowas-in`、`as-override`

### 4. 再配送（Redistribution）（Week 27）⭐最重要
> **ENARSI で一番事故りやすく、一番出る。**

```cisco
! OSPF → EIGRP
router eigrp 100
 redistribute ospf 1 metric 1000000 100 255 1 1500

! EIGRP → OSPF
router ospf 1
 redistribute eigrp 100 subnets
 ! subnets を忘れるとクラスフルな経路しか入らない ← 定番の罠

! 静的 → OSPF（route-map で絞る）
ip prefix-list ALLOW-STATIC seq 5 permit 172.16.0.0/16 le 24
route-map RM-STATIC permit 10
 match ip address prefix-list ALLOW-STATIC
 set metric 100
 set metric-type type-1
!
router ospf 1
 redistribute static subnets route-map RM-STATIC
```

**必須メトリック（デフォルト値が無いプロトコル）**
| 再配送先 | デフォルトメトリック | 備考 |
|---------|-------------------|------|
| **EIGRP** | **無い** → 必須指定 | `metric BW DELAY REL LOAD MTU` または `default-metric` |
| **OSPF** | 20（BGP からは 1） | `subnets` を忘れない |
| RIP | 無い → 必須指定 | |
| BGP | IGP メトリックを継承 | |

**再配送の 3 大トラブル**
| 現象 | 原因 | 対策 |
|------|------|------|
| **ルーティングループ** | 相互再配送で経路が往復 | route-map / tag でフィルタ |
| **次善経路の選択** | AD の差で遠回りの経路を選ぶ | `distance` で AD を調整 |
| **経路が入らない** | メトリック未指定 / `subnets` 忘れ | `show ip protocols` で確認 |

**タグを使ったループ防止（定番テクニック）**
```cisco
! OSPF から入れるとき tag 100 を付ける
route-map OSPF-TO-EIGRP permit 10
 set tag 100
!
! 戻すときは tag 100 を弾く
route-map EIGRP-TO-OSPF deny 10
 match tag 100
route-map EIGRP-TO-OSPF permit 20
```
```cisco
show ip route <prefix>          ! tag が見える
show ip protocols               ! 再配送の状況が全部書いてある
```
> 🔥 **`show ip protocols` は再配送トラブルの最重要コマンド。**
> 「何を」「どこへ」「どのメトリックで」「どのフィルタで」再配送しているかが全部出る。

### 5. VPN（Week 28-29）
- MPLS の基本：LDP、ラベルスタック、PE/P/CE
```cisco
mpls ip
mpls label protocol ldp
interface GigabitEthernet0/0
 mpls ip
!
show mpls interfaces
show mpls ldp neighbor
show mpls forwarding-table
```
- **MPLS L3VPN**：VRF + RD（経路の一意化）+ RT（経路のインポート/エクスポート）
- **DMVPN**：NHRP + mGRE + IPsec、Phase 1/2/3 の違い
```cisco
interface Tunnel0
 ip address 172.16.0.1 255.255.255.0
 ip nhrp network-id 100
 ip nhrp map multicast dynamic
 ip nhrp authentication CcnpNhrp
 tunnel source GigabitEthernet0/0
 tunnel mode gre multipoint
!
show dmvpn
show ip nhrp
show ip nhrp brief
```

### 6. インフラストラクチャサービス（Week 30）
```cisco
! --- SNMP ---
snmp-server community CcnpRO RO 10
snmp-server host 192.168.99.50 version 2c CcnpRO
snmp-server enable traps
! SNMPv3（推奨）
snmp-server group GRP1 v3 priv
snmp-server user USER1 GRP1 v3 auth sha AuthPass123 priv aes 128 PrivPass123
show snmp
show snmp user

! --- Syslog ---
logging host 192.168.99.50
logging trap informational
logging buffered 32768 debugging
logging source-interface Loopback0
show logging

! --- NTP ---
ntp server 192.168.99.10 prefer
ntp authenticate
ntp authentication-key 1 md5 CcnpNtp
ntp trusted-key 1
show ntp status
show ntp associations

! --- NetFlow (Flexible NetFlow) ---
flow record FR1
 match ipv4 source address
 match ipv4 destination address
 match transport source-port
 match transport destination-port
 collect counter bytes
 collect counter packets
!
flow exporter FE1
 destination 192.168.99.50
 transport udp 2055
 source Loopback0
!
flow monitor FM1
 record FR1
 exporter FE1
 cache timeout active 60
!
interface GigabitEthernet0/0
 ip flow monitor FM1 input
!
show flow monitor FM1 cache
show flow exporter FE1

! --- IP SLA + トラッキング ---
ip sla 1
 icmp-echo 8.8.8.8 source-interface GigabitEthernet0/1
 frequency 10
ip sla schedule 1 life forever start-time now
!
track 1 ip sla 1 reachability
!
ip route 0.0.0.0 0.0.0.0 203.0.113.1 track 1
ip route 0.0.0.0 0.0.0.0 198.51.100.1 100     ! フローティングスタティック
!
show ip sla statistics
show ip sla configuration
show track
```

### 7. インフラストラクチャセキュリティ（Week 31）
- ACL（標準/拡張/時間ベース/IPv6）
- uRPF、Control Plane Policing
- Device Access Control（AAA、`privilege level`）
```cisco
! uRPF
interface GigabitEthernet0/1
 ip verify unicast source reachable-via rx

! 時間ベース ACL
time-range WORK-HOURS
 periodic weekdays 09:00 to 18:00
!
ip access-list extended TIME-ACL
 permit tcp any any eq 80 time-range WORK-HOURS

! IPv6 ACL
ipv6 access-list V6-ACL
 permit tcp any any eq 443
 deny ipv6 any any log
!
interface GigabitEthernet0/0
 ipv6 traffic-filter V6-ACL in
```

### 8. 総合トラブルシュート（Week 32）
`../commands/show-debug-troubleshooting.md` の切り分けフローを使って、
**自分で仕込んだ「壊れたラボ」を 10 問、時間を計って解く。**

---

## ✅ ENARSI 卒業条件
- [ ] EIGRP の FD / RD と Feasibility Condition を説明できる
- [ ] 相互再配送のループを**自分で発生させて、tag で直した**
- [ ] `show ip protocols` から再配送の設定を読み取れる
- [ ] DMVPN を構築し、スポーク間通信を確認した
- [ ] IP SLA + track で経路が自動切替されるのを観測した
- [ ] 「壊れたラボ」10 問を平均 15 分以内で解けた
- [ ] Ping-t 模擬 90% 以上 × 3 回連続
