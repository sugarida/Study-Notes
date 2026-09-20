# Lab 07：セキュリティ（20%）と QoS 🔐
**対象週：Week 15-16**

---

## Part A：ACL

```cisco
! --- 名前付き拡張 ACL（実務・試験ともこれが基本）---
ip access-list extended WEB-ONLY
 permit tcp 192.168.10.0 0.0.0.255 any eq 80
 permit tcp 192.168.10.0 0.0.0.255 any eq 443
 permit udp 192.168.10.0 0.0.0.255 any eq 53
 permit icmp 192.168.10.0 0.0.0.255 any echo-reply
 deny   ip any any log
!
interface GigabitEthernet0/0
 ip access-group WEB-ONLY in
```

### シーケンス番号での編集（丸ごと消さずに直す）
```cisco
ip access-list extended WEB-ONLY
 15 permit tcp 192.168.10.0 0.0.0.255 any eq 22    ! 10 と 20 の間に挿入
 no 15                                              ! 削除
 resequence                                         ! 番号振り直し(機種による)
```

### 確認
```cisco
show access-lists
show access-lists WEB-ONLY
show ip interface GigabitEthernet0/0 | include access list
clear access-list counters WEB-ONLY
```
```
Extended IP access list WEB-ONLY
    10 permit tcp 192.168.10.0 0.0.0.255 any eq www (245 matches)   ← ★ マッチ数
    20 permit tcp 192.168.10.0 0.0.0.255 any eq 443 (1102 matches)
    30 deny ip any any log (17 matches)
```
> 🔥 **マッチ数（matches）が ACL トラブルシュートの主役。**
> 「通らない」なら deny 行のカウンタが増えているはず。増えていないなら**そもそも ACL を通っていない**
> （インターフェースへの適用ミス、方向ミス）。

### 暗記ポイント
- 最後に**暗黙の `deny ip any any`** がある（ログには出ない）
- 上から順に評価、**マッチした時点で終了**
- 標準 ACL は**送信元のみ**判定 → 宛先の近くに置く
- 拡張 ACL は送信元+宛先+プロトコル+ポート → **送信元の近くに置く**
- インターフェース + 方向（in/out）ごとに 1 つだけ適用できる

---

## Part B：インフラ保護

### CoPP（Control Plane Policing）
```cisco
! 分類
ip access-list extended ACL-SSH
 permit tcp 192.168.99.0 0.0.0.255 any eq 22
ip access-list extended ACL-ICMP
 permit icmp any any
!
class-map match-all CM-SSH
 match access-group name ACL-SSH
class-map match-all CM-ICMP
 match access-group name ACL-ICMP
!
policy-map PM-COPP
 class CM-SSH
  police 64000 conform-action transmit exceed-action drop
 class CM-ICMP
  police 32000 conform-action transmit exceed-action drop
 class class-default
  police 1000000 conform-action transmit exceed-action drop
!
control-plane
 service-policy input PM-COPP
```
```cisco
show policy-map control-plane
show policy-map control-plane input
```
> **CoPP の目的：制御プレーン（CPU）を守る。** DoS で CPU 100% になるのを防ぐ。

### 管理アクセスの保護
```cisco
! VTY に ACL
ip access-list standard MGMT-HOSTS
 permit 192.168.99.0 0.0.0.255
!
line vty 0 4
 access-class MGMT-HOSTS in
 transport input ssh
 exec-timeout 5 0
!
! ログイン試行の制限
login block-for 120 attempts 3 within 60
login on-failure log
login on-success log
!
! パスワード保護
service password-encryption
enable secret <強いパスワード>
security passwords min-length 10
```

### DHCP Snooping / DAI / Port Security（L2 保護）
```cisco
! --- DHCP Snooping ---
ip dhcp snooping
ip dhcp snooping vlan 10,20
no ip dhcp snooping information option
!
interface GigabitEthernet0/1
 description ** 正規DHCPサーバ側 = trust **
 ip dhcp snooping trust
!
! --- Dynamic ARP Inspection（DHCP Snooping が前提）---
ip arp inspection vlan 10,20
interface GigabitEthernet0/1
 ip arp inspection trust
!
! --- Port Security ---
interface GigabitEthernet0/10
 switchport mode access
 switchport port-security
 switchport port-security maximum 2
 switchport port-security mac-address sticky
 switchport port-security violation restrict
```
```cisco
show ip dhcp snooping
show ip dhcp snooping binding
show ip arp inspection
show port-security
show port-security interface GigabitEthernet0/10
```

| violation モード | フレーム破棄 | ログ/SNMP | ポート状態 |
|-----------------|-------------|----------|-----------|
| **protect** | ✅ | ❌ | up のまま |
| **restrict** | ✅ | ✅ | up のまま |
| **shutdown**（既定） | ✅ | ✅ | **err-disabled** |

---

## Part C：AAA（TACACS+ / RADIUS）

```cisco
aaa new-model
!
! --- TACACS+ ---
tacacs server ISE1
 address ipv4 192.168.99.50
 key CcnpTacacsKey
!
aaa group server tacacs+ TAC-GROUP
 server name ISE1
!
! --- 認証・認可・アカウンティング ---
aaa authentication login default group TAC-GROUP local
aaa authorization exec default group TAC-GROUP local
aaa authorization commands 15 default group TAC-GROUP local
aaa accounting commands 15 default start-stop group TAC-GROUP
!
! ローカルの退避ユーザを必ず残す（締め出し防止）
username admin privilege 15 secret <強いパスワード>
```
```cisco
show aaa servers
show tacacs
test aaa group TAC-GROUP admin <password> legacy
debug aaa authentication
```

### TACACS+ と RADIUS の比較（超頻出）
| 項目 | TACACS+ | RADIUS |
|------|---------|--------|
| 提供元 | **Cisco 独自** | 業界標準（RFC） |
| トランスポート | **TCP 49** | **UDP 1812/1813**（旧 1645/1646） |
| 暗号化範囲 | **パケット全体** | **パスワードのみ** |
| AAA の分離 | **認証・認可・課金が独立** | 認証と認可が一体 |
| 主用途 | **機器の管理者ログイン（コマンド認可）** | **ユーザのネットワーク接続認証（802.1X）** |

> 🔥 「コマンド単位で認可したい」→ **TACACS+**。「802.1X で端末を認証したい」→ **RADIUS**。

---

## Part D：QoS

### 流れ（この順番で覚える）
```
分類(Classify) → マーキング(Mark) → キューイング(Queue) → シェーピング/ポリシング
```

### マーキングの値
| 名称 | ビット位置 | 値の例 |
|------|-----------|--------|
| **CoS** | L2（802.1Q タグ内 3bit） | 0-7 |
| **DSCP** | L3（IP ToS の上位 6bit） | 0-63 |
| IP Precedence | L3（上位 3bit、DSCP の前身） | 0-7 |

| DSCP 名 | 10進 | 用途 |
|---------|------|------|
| **EF**（Expedited Forwarding） | **46** | **音声（VoIP）** |
| AF41 | 34 | ビデオ |
| AF31 | 26 | 重要データ・コールシグナリング(CS3=24 も) |
| AF21 | 18 | トランザクションデータ |
| CS6 | 48 | ルーティングプロトコル |
| **BE**（Default） | **0** | ベストエフォート |

> 📌 **音声 = EF(46) は必ず覚える。** 「音声に使う DSCP は？」は定番問題。

### MQC（Modular QoS CLI）の設定
```cisco
! 1) 分類
class-map match-any CM-VOICE
 match protocol rtp
 match dscp ef
class-map match-all CM-VIDEO
 match dscp af41
!
! 2) ポリシー定義
policy-map PM-WAN-OUT
 class CM-VOICE
  priority percent 10                  ! LLQ（低遅延キュー）
  set dscp ef
 class CM-VIDEO
  bandwidth percent 30                 ! CBWFQ
 class class-default
  fair-queue
  random-detect dscp-based             ! WRED
!
! 3) 適用
interface GigabitEthernet0/1
 service-policy output PM-WAN-OUT
```

### シェーピング と ポリシング（頻出の対比）
```cisco
! ポリシング：超過分を "捨てる" or 再マークする
policy-map PM-POLICE
 class class-default
  police 8000000 conform-action transmit exceed-action drop

! シェーピング：超過分を "バッファに貯めて遅らせる"
policy-map PM-SHAPE
 class class-default
  shape average 8000000
```
| | ポリシング | シェーピング |
|---|-----------|-------------|
| 超過分 | **破棄 / 再マーク** | **バッファして遅延送出** |
| 適用方向 | in / out | **out のみ** |
| バースト | 吸収しない | 吸収する |
| 遅延 | 増やさない | **増える** |
| TCP への影響 | 再送が増える | 再送は減る |

### 確認
```cisco
show policy-map
show policy-map interface GigabitEthernet0/1
show class-map
show mls qos               ! 機種による
```

### 信頼境界（Trust Boundary）
```cisco
interface GigabitEthernet1/0/10
 mls qos trust dscp        ! または trust cos / trust device cisco-phone
```
> **信頼境界はできるだけエッジ（端末に近い場所）に置く。**
> 信頼していない端末が付けたマーキングは、そこで書き換える（再マーク）。

---

## ✅ 卒業条件
- [ ] ACL で「HTTP だけ通す」を構築し、マッチ数で検証した
- [ ] `deny` のカウンタを見て、通らない原因を特定できた
- [ ] TACACS+ と RADIUS の比較表を**書き出せる**
- [ ] port-security の violation 3 モードの違いを言える
- [ ] DSCP EF = 46 を含む主要な値を覚えた
- [ ] ポリシングとシェーピングの違いを**5 項目で説明できる**
