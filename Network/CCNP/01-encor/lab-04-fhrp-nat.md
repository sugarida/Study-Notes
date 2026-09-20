# Lab 04：FHRP（HSRP / VRRP / GLBP）と NAT 🛡️
**対象週：Week 11-12**

---

## Part A：FHRP

### トポロジ
```
      [R1]        [R2]      ← 仮想IP 192.168.10.254 を共有
        |           |
        +---[SW1]---+
             |
           [PC1] 192.168.10.100  (GW: 192.168.10.254)
```

### HSRP（Cisco 独自）

```cisco
! --- R1（Active にしたい側）---
interface GigabitEthernet0/0
 ip address 192.168.10.1 255.255.255.0
 standby version 2
 standby 10 ip 192.168.10.254
 standby 10 priority 110
 standby 10 preempt
 standby 10 authentication md5 key-string CcnpLab
 standby 10 timers msec 250 msec 750
 standby 10 track 1 decrement 20

! --- R2（Standby）---
interface GigabitEthernet0/0
 ip address 192.168.10.2 255.255.255.0
 standby version 2
 standby 10 ip 192.168.10.254
 standby 10 priority 100
 standby 10 preempt
```

#### オブジェクトトラッキング（上流障害で切り替える）
```cisco
track 1 interface GigabitEthernet0/1 line-protocol
! もしくは経路の有無で
track 2 ip route 0.0.0.0 0.0.0.0 reachability
```
```cisco
show track
show track 1
```

#### 確認
```cisco
show standby
show standby brief
show standby GigabitEthernet0/0 10
debug standby events
```
`show standby brief`:
```
Interface   Grp  Pri P State   Active          Standby         Virtual IP
Gi0/0       10   110 P Active  local           192.168.10.2    192.168.10.254
```
- `P` = preempt 有効
- `State` が両側 Active → **スプリットブレイン（Hello が届いていない）**

#### HSRP 暗記ポイント
| 項目 | v1 | v2 |
|------|----|----|
| グループ番号 | 0-255 | **0-4095** |
| マルチキャスト | 224.0.0.2 | **224.0.0.102** |
| 仮想MAC | 0000.0C07.**AC**xx | 0000.0C9F.**F**xxx |
| IPv6 | 非対応 | **対応** |
| ミリ秒タイマ | 非対応 | 対応 |

- UDP 1985（v1）/ 1985（v2 IPv4）
- **プリエンプトはデフォルト無効** ← 超頻出
- デフォルト優先度 100、Hello 3秒 / Hold 10秒

### VRRP（業界標準 RFC）
```cisco
interface GigabitEthernet0/0
 vrrp 10 ip 192.168.10.254
 vrrp 10 priority 110
 vrrp 10 authentication md5 key-string CcnpLab
! preempt はデフォルト有効（無効化する場合）
 no vrrp 10 preempt
```
```cisco
show vrrp
show vrrp brief
```
| 項目 | 値 |
|------|-----|
| マルチキャスト | **224.0.0.18** |
| プロトコル番号 | **112**（IP プロトコル、UDP ではない） |
| 仮想MAC | 0000.5E00.01xx |
| 役割名 | **Master / Backup**（Active/Standby ではない） |
| プリエンプト | **デフォルト有効** ← HSRP との違いが頻出 |
| タイマ | Advertisement 1秒 |

### GLBP（Cisco 独自・ロードバランス可）
```cisco
interface GigabitEthernet0/0
 glbp 10 ip 192.168.10.254
 glbp 10 priority 110
 glbp 10 preempt
 glbp 10 load-balancing round-robin
```
```cisco
show glbp
show glbp brief
```
| 項目 | 値 |
|------|-----|
| マルチキャスト | **224.0.0.102** |
| UDP ポート | 3222 |
| 役割 | **AVG**（仮想MACを配る）/ **AVF**（実際に転送する） |
| ロードバランス | round-robin / weighted / host-dependent |

> 🔥 **GLBP だけが複数ルータで同時に転送できる（ロードバランス）。**
> HSRP/VRRP はグループを複数作って VLAN ごとに Active を分ける方式（MHSRP）でしか分散できない。

### 🔨 わざと壊す
| # | 壊し方 | 症状 |
|---|--------|------|
| 1 | R2 の優先度を 120 にするが preempt を入れない | **切り替わらない**（優先度が高くても奪わない） |
| 2 | 片側だけ `standby version 2` | 仮想MACが違い、両方 Active |
| 3 | グループ番号を片側だけ 20 に | 両方 Active |
| 4 | 認証キーを片側だけ変える | 両方 Active + ログ |
| 5 | 上流 IF を落とす（track あり） | 優先度が 20 下がり切替 → `show standby` で確認 |

---

## Part B：NAT / PAT

### 静的 NAT
```cisco
interface GigabitEthernet0/0
 description INSIDE
 ip address 192.168.10.1 255.255.255.0
 ip nat inside
!
interface GigabitEthernet0/1
 description OUTSIDE
 ip address 203.0.113.1 255.255.255.0
 ip nat outside
!
ip nat inside source static 192.168.10.100 203.0.113.100
```

### 動的 NAT（プール）
```cisco
ip nat pool POOL1 203.0.113.10 203.0.113.20 netmask 255.255.255.0
access-list 1 permit 192.168.10.0 0.0.0.255
ip nat inside source list 1 pool POOL1
```

### PAT（NAT Overload）
```cisco
! プール利用
ip nat inside source list 1 pool POOL1 overload
! 出口インターフェースのIPを使う（最も一般的）
ip nat inside source list 1 interface GigabitEthernet0/1 overload
```

### 静的 PAT（ポートフォワード）
```cisco
ip nat inside source static tcp 192.168.10.50 80 203.0.113.1 8080
```

### 確認
```cisco
show ip nat translations
show ip nat translations verbose
show ip nat statistics
clear ip nat translation *
debug ip nat
```
`show ip nat translations`:
```
Pro Inside global      Inside local       Outside local      Outside global
tcp 203.0.113.1:1024   192.168.10.100:1024 198.51.100.5:80   198.51.100.5:80
```

### 用語（最頻出の引っかけ）
| 用語 | 意味 |
|------|------|
| **Inside Local** | 内部ネットワークから見た内部ホストの実アドレス（プライベート） |
| **Inside Global** | 外部から見た内部ホストのアドレス（変換後・グローバル） |
| **Outside Local** | 内部から見た外部ホストのアドレス |
| **Outside Global** | 外部ホストの実アドレス |

> 📌 **Local = 内部視点のアドレス / Global = 外部視点のアドレス**
> **Inside = 内部ホストのこと / Outside = 外部ホストのこと**
> この 2 軸で 4 通り、と覚える。

### 🔨 わざと壊す
| # | 壊し方 | 症状 | 確認 |
|---|--------|------|------|
| 1 | `ip nat inside` を付け忘れる | 変換テーブルが空のまま | `show ip nat statistics` の Hits が増えない |
| 2 | inside / outside を逆に付ける | 変換されない | `show ip nat statistics` |
| 3 | ACL の範囲を間違える | 一部 PC だけ通らない | `show access-lists`（マッチ数を見る） |
| 4 | `overload` を付け忘れる（プール小） | プール枯渇で後続が通らない | `show ip nat statistics` の "misses" |
| 5 | 戻りの経路が無い | 変換はされるが応答が来ない | `show ip route` を上流で確認 |

> 💡 **NAT が効かないとき、9 割は `ip nat inside/outside` の付け忘れか向き間違い。**
> まず `show ip nat statistics` の Hits / Misses を見る。

---

## ✅ 卒業条件
- [ ] HSRP を白紙から構築し、track で切替を観測した
- [ ] HSRP / VRRP / GLBP の比較表を**書き出せる**
- [ ] プリエンプトのデフォルト値の違いを即答できる
- [ ] Inside Local / Global / Outside Local / Global を説明できる
- [ ] PAT を構築し、`show ip nat translations` でポート変換を確認した
