# CCNP コマンド逆引きチートシート ⚡
**用途：試験直前の最終確認 / ラボ中の逆引き**

> 使い方：**まず何も見ずに書き出してみる → このファイルと突き合わせる。**
> 8 割書ければ Lv.2 到達。

---

## 0. 基本操作

| やりたいこと | コマンド |
|--------------|----------|
| 設定モードへ | `configure terminal` |
| 設定を保存 | `write memory` / `copy running-config startup-config` |
| 設定を確認 | `show running-config` |
| 部分だけ見る | `show running-config \| section ospf` |
| 検索 | `show run \| include hostname` / `\| begin interface` / `\| exclude !` |
| インターフェースだけ | `show running-config interface Gi0/0` |
| 設定を消す | 先頭に `no` を付ける |
| 一行前の設定に戻る | `do show ...`（設定モードから show を打つ） |
| 設定初期化 | `write erase` → `reload` |

---

## 1. L2（VLAN / STP / EtherChannel）

### 設定
```cisco
vlan 10
 name USERS
!
interface Gi0/1
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,20,99
 switchport trunk native vlan 99
!
interface Gi0/10
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
 spanning-tree bpduguard enable
!
spanning-tree mode rapid-pvst | mst
spanning-tree vlan 10 root primary | secondary
spanning-tree vlan 10 priority 4096
!
spanning-tree mst configuration
 name REGION1
 revision 1
 instance 1 vlan 10,20
!
interface range Gi0/1 - 2
 channel-group 1 mode active | passive | desirable | auto | on
port-channel load-balance src-dst-ip
```

### 確認
```cisco
show vlan brief
show interfaces trunk
show interfaces status
show interfaces Gi0/1 switchport
show spanning-tree
show spanning-tree vlan 10
show spanning-tree root
show spanning-tree summary
show spanning-tree mst
show spanning-tree mst configuration
show spanning-tree mst configuration digest
show etherchannel summary
show etherchannel 1 port-channel
show lacp neighbor
show lacp 1 internal
show pagp neighbor
show mac address-table
show mac address-table interface Gi0/10
```

---

## 2. OSPF

### 設定
```cisco
router ospf 1
 router-id 1.1.1.1
 network 10.1.2.0 0.0.0.3 area 0
 passive-interface default
 no passive-interface Gi0/0
 auto-cost reference-bandwidth 100000
 area 1 stub [no-summary]
 area 2 nssa [no-summary] [default-information-originate]
 area 1 range 192.168.0.0 255.255.252.0      ! ABR で集約
 summary-address 172.16.0.0 255.255.0.0      ! ASBR で集約
 default-information originate [always]
 area 0 authentication message-digest
 area 1 virtual-link 3.3.3.3
!
interface Gi0/0
 ip ospf 1 area 0
 ip ospf network point-to-point | broadcast | non-broadcast | point-to-multipoint
 ip ospf cost 10
 ip ospf priority 0-255
 ip ospf hello-interval 10
 ip ospf dead-interval 40
 ip ospf authentication message-digest
 ip ospf message-digest-key 1 md5 KEY
 ip ospf mtu-ignore
!
! OSPFv3
ipv6 unicast-routing
interface Gi0/0
 ipv6 ospf 1 area 0
ipv6 router ospf 1
 router-id 1.1.1.1
```

### 確認
```cisco
show ip ospf
show ip ospf neighbor [detail]
show ip ospf interface [brief | Gi0/0]
show ip ospf database [router|network|summary|external|nssa-external]
show ip ospf border-routers
show ip route ospf
show ip protocols
clear ip ospf process
debug ip ospf adj
debug ip ospf hello
! IPv6
show ipv6 ospf neighbor
show ipv6 ospf interface brief
show ipv6 route ospf
```

---

## 3. EIGRP

### 設定
```cisco
! クラシック構文
router eigrp 100
 network 10.0.0.0 0.255.255.255
 no auto-summary
 eigrp router-id 1.1.1.1
 variance 2
 passive-interface default
 no passive-interface Gi0/0
!
interface Gi0/0
 ip summary-address eigrp 100 192.168.0.0 255.255.252.0
 ip hello-interval eigrp 100 5
 ip hold-time eigrp 100 15
 ip bandwidth-percent eigrp 100 50
!
! 名前付き構文（IOS-XE）
router eigrp CCNP
 address-family ipv4 unicast autonomous-system 100
  network 10.0.0.0 0.255.255.255
  eigrp router-id 1.1.1.1
  af-interface Gi0/0
   hello-interval 5
   hold-time 15
   authentication mode md5
  exit-af-interface
 exit-address-family
```

### 確認
```cisco
show ip eigrp neighbors [detail]
show ip eigrp topology [all-links]
show ip eigrp interfaces [detail]
show ip eigrp traffic
show ip route eigrp
show ip protocols
debug eigrp packets
debug ip eigrp
```

---

## 4. BGP

### 設定
```cisco
router bgp 65001
 bgp router-id 1.1.1.1
 bgp log-neighbor-changes
 no bgp default ipv4-unicast
 neighbor 10.1.2.2 remote-as 65002
 neighbor 3.3.3.3 remote-as 65001
 neighbor 3.3.3.3 update-source Loopback0
 neighbor 4.4.4.4 ebgp-multihop 2
 neighbor 10.1.2.2 password SECRET
 neighbor 10.1.2.2 shutdown
 !
 address-family ipv4 unicast
  neighbor 10.1.2.2 activate
  neighbor 3.3.3.3 next-hop-self
  neighbor 3.3.3.3 route-reflector-client
  neighbor 10.1.2.2 route-map POLICY in | out
  neighbor 10.1.2.2 prefix-list PL1 in | out
  neighbor 10.1.2.2 filter-list 1 in | out
  neighbor 10.1.2.2 soft-reconfiguration inbound
  neighbor 10.1.2.2 send-community
  neighbor 10.1.2.2 maximum-prefix 1000 80
  neighbor 10.1.2.2 weight 200
  network 192.168.1.0 mask 255.255.255.0
  aggregate-address 192.168.0.0 255.255.252.0 [summary-only]
  redistribute ospf 1
 exit-address-family
```

### 確認
```cisco
show ip bgp summary
show ip bgp
show ip bgp 192.168.1.0/24
show ip bgp neighbors [x.x.x.x]
show ip bgp neighbors x.x.x.x advertised-routes
show ip bgp neighbors x.x.x.x received-routes
show ip bgp neighbors x.x.x.x routes
show ip bgp regexp ^65001$
show ip bgp community 65001:100
show ip route bgp
clear ip bgp * soft
clear ip bgp x.x.x.x soft in | out
debug ip bgp [updates]
```

---

## 5. 経路制御ツール（route-map / prefix-list）

```cisco
! prefix-list（ge / le で範囲指定）
ip prefix-list PL1 seq 5 permit 192.168.0.0/16 le 24
ip prefix-list PL1 seq 10 deny 10.0.0.0/8 ge 16 le 24
show ip prefix-list [detail]

! AS-PATH ACL（正規表現）
ip as-path access-list 1 permit ^$           ! 自AS発
ip as-path access-list 2 permit ^65001$      ! 隣接AS 65001 発
ip as-path access-list 3 permit _65003_      ! 経路に65003を含む
ip as-path access-list 4 permit .*           ! すべて

! route-map
route-map RM1 permit 10
 match ip address prefix-list PL1
 match tag 100
 match as-path 1
 set local-preference 200
 set weight 100
 set metric 50
 set metric-type type-1 | type-2
 set as-path prepend 65001 65001
 set community 65001:100 [additive]
 set tag 100
 set ip next-hop 10.1.1.1
route-map RM1 permit 20        ! ★暗黙の deny 対策
show route-map
```

### 正規表現（BGP AS-PATH）
| 記号 | 意味 |
|------|------|
| `^` | 先頭 |
| `$` | 末尾 |
| `_` | 区切り（スペース、先頭、末尾、カンマ） |
| `.` | 任意の 1 文字 |
| `*` | 直前の 0 回以上の繰り返し |
| `+` | 直前の 1 回以上 |
| `?` | 直前の 0 or 1 回 |
| `[]` | 文字クラス |

---

## 6. 再配送

```cisco
router ospf 1
 redistribute eigrp 100 subnets [metric 100] [metric-type 1|2] [route-map RM1] [tag 100]
 redistribute bgp 65001 subnets
 redistribute static subnets
 redistribute connected subnets
!
router eigrp 100
 redistribute ospf 1 metric 1000000 100 255 1 1500
 default-metric 1000000 100 255 1 1500
!
router bgp 65001
 address-family ipv4
  redistribute ospf 1 match internal external 1 external 2
!
! AD の調整
router ospf 1
 distance 115
 distance ospf external 130
router eigrp 100
 distance eigrp 90 170
```
```cisco
show ip protocols          ! ★再配送の全貌が見える
show ip route <prefix>     ! tag / AD / メトリックが見える
```

### AD（管理距離）一覧 ★暗記必須
| プロトコル | AD |
|-----------|-----|
| 直接接続 | **0** |
| 静的ルート | **1** |
| EIGRP サマリー | 5 |
| **eBGP** | **20** |
| **EIGRP（内部）** | **90** |
| **OSPF** | **110** |
| IS-IS | 115 |
| **RIP** | **120** |
| EIGRP（外部） | **170** |
| **iBGP** | **200** |
| 未知 / 使用不可 | 255 |

---

## 7. FHRP

```cisco
! HSRP
interface Gi0/0
 standby version 2
 standby 10 ip 192.168.10.254
 standby 10 priority 110
 standby 10 preempt [delay minimum 60]
 standby 10 timers [msec 250] [msec 750]
 standby 10 authentication md5 key-string KEY
 standby 10 track 1 decrement 20
show standby [brief]

! VRRP
interface Gi0/0
 vrrp 10 ip 192.168.10.254
 vrrp 10 priority 110
 vrrp 10 preempt
show vrrp [brief]

! GLBP
interface Gi0/0
 glbp 10 ip 192.168.10.254
 glbp 10 priority 110
 glbp 10 preempt
 glbp 10 load-balancing round-robin | weighted | host-dependent
show glbp [brief]

! トラッキング
track 1 interface Gi0/1 line-protocol
track 2 ip route 0.0.0.0 0.0.0.0 reachability
track 3 ip sla 1 reachability
show track
```

---

## 8. NAT

```cisco
interface Gi0/0
 ip nat inside
interface Gi0/1
 ip nat outside
!
ip nat inside source static 192.168.10.100 203.0.113.100
ip nat inside source static tcp 192.168.10.50 80 203.0.113.1 8080
ip nat pool POOL1 203.0.113.10 203.0.113.20 netmask 255.255.255.0
ip nat inside source list 1 pool POOL1 [overload]
ip nat inside source list 1 interface Gi0/1 overload
!
show ip nat translations [verbose]
show ip nat statistics
clear ip nat translation *
debug ip nat
```

---

## 9. VRF / トンネル

```cisco
vrf definition CUST_A
 rd 65001:1
 address-family ipv4
!
interface Gi0/1
 vrf forwarding CUST_A      ! ★先に VRF、後から IP
 ip address 192.168.1.1 255.255.255.0
!
ip route vrf CUST_A 0.0.0.0 0.0.0.0 192.168.1.254
show vrf [detail]
show ip route vrf CUST_A
ping vrf CUST_A 192.168.1.254

! GRE
interface Tunnel0
 ip address 172.16.0.1 255.255.255.252
 tunnel source Gi0/0
 tunnel destination 203.0.113.2
 tunnel mode gre ip | gre multipoint | ipsec ipv4
 ip mtu 1400
 ip tcp adjust-mss 1360
 tunnel protection ipsec profile IPSEC-PROF
!
show interfaces Tunnel0
show crypto ikev2 sa
show crypto ipsec sa
show crypto session
show dmvpn
show ip nhrp
```

---

## 10. セキュリティ

```cisco
! ACL
ip access-list extended ACL1
 permit tcp 192.168.10.0 0.0.0.255 any eq 443
 deny ip any any log
interface Gi0/0
 ip access-group ACL1 in
show access-lists
clear access-list counters

! Port Security
interface Gi0/10
 switchport port-security
 switchport port-security maximum 2
 switchport port-security mac-address sticky
 switchport port-security violation protect|restrict|shutdown
show port-security [interface Gi0/10]

! DHCP Snooping / DAI
ip dhcp snooping
ip dhcp snooping vlan 10
interface Gi0/1
 ip dhcp snooping trust
ip arp inspection vlan 10
show ip dhcp snooping [binding]
show ip arp inspection

! AAA
aaa new-model
tacacs server ISE1
 address ipv4 192.168.99.50
 key KEY
aaa authentication login default group tacacs+ local
aaa authorization exec default group tacacs+ local
show aaa servers
test aaa group tacacs+ user pass legacy

! uRPF
interface Gi0/1
 ip verify unicast source reachable-via rx
```

---

## 11. QoS

```cisco
class-map match-any CM-VOICE
 match dscp ef
policy-map PM-OUT
 class CM-VOICE
  priority percent 10
 class class-default
  bandwidth percent 40
  fair-queue
  random-detect
interface Gi0/1
 service-policy output PM-OUT
!
police 8000000 conform-action transmit exceed-action drop
shape average 8000000
!
show policy-map [interface Gi0/1]
show class-map
```

---

## 12. 自動化 / 管理サービス

```cisco
netconf-yang
restconf
ip http secure-server
show netconf-yang sessions
show platform software yang-management process
!
! SNMP
snmp-server community RO_STRING RO 10
snmp-server host 192.168.99.50 version 2c RO_STRING
snmp-server user USER1 GRP1 v3 auth sha PASS priv aes 128 PASS
show snmp [user]
!
! Syslog / NTP
logging host 192.168.99.50
logging trap informational
logging buffered 32768
show logging
!
ntp server 192.168.99.10 prefer
show ntp status
show ntp associations
!
! NetFlow / IP SLA
show flow monitor FM1 cache
show flow exporter
ip sla 1
 icmp-echo 8.8.8.8
ip sla schedule 1 life forever start-time now
show ip sla statistics
!
! EEM
event manager applet TEST
 event syslog pattern "..."
 action 1.0 syslog msg "..."
show event manager policy registered
```

---

## 13. 数字の暗記表（試験直前用）

### ポート番号
| サービス | ポート |
|---------|--------|
| FTP | 20(data) / 21(control) |
| SSH | 22 |
| Telnet | 23 |
| DNS | 53 |
| DHCP | 67(server) / 68(client) |
| TFTP | 69 |
| HTTP | 80 |
| NTP | **123** |
| HTTPS / RESTCONF | **443** |
| Syslog | **514** |
| RADIUS | **1812 / 1813**（旧 1645/1646） |
| TACACS+ | **49（TCP）** |
| SNMP | **161 / 162(trap)** |
| BGP | **179（TCP）** |
| **NETCONF** | **830（SSH）** |
| CAPWAP | **5246(control) / 5247(data)** |
| VXLAN | **4789（UDP）** |
| IKE / NAT-T | 500 / **4500** |
| NetFlow（一般的な設定値） | 2055（任意） |

### マルチキャストアドレス
| 用途 | アドレス |
|------|----------|
| 全ホスト | 224.0.0.1 |
| 全ルータ | 224.0.0.2（HSRPv1 も） |
| **OSPF 全ルータ** | **224.0.0.5** |
| **OSPF DR/BDR** | **224.0.0.6** |
| RIPv2 | 224.0.0.9 |
| **EIGRP** | **224.0.0.10** |
| **VRRP** | **224.0.0.18** |
| **HSRPv2 / GLBP** | **224.0.0.102** |

### プロトコル番号
| プロトコル | 番号 |
|-----------|------|
| ICMP | 1 |
| IGMP | 2 |
| TCP | 6 |
| UDP | 17 |
| GRE | 47 |
| **ESP** | **50** |
| **AH** | **51** |
| EIGRP | 88 |
| OSPF | 89 |
| **VRRP** | **112** |

### タイマ
| プロトコル | Hello | Dead/Hold |
|-----------|-------|-----------|
| OSPF（Broadcast/P2P） | 10 | 40 |
| OSPF（NBMA/P2MP） | 30 | 120 |
| EIGRP（高速IF） | 5 | 15 |
| EIGRP（低速IF） | 60 | 180 |
| HSRP | 3 | 10 |
| VRRP | 1 | 3 |
| BGP Keepalive/Hold | 60 | 180 |
| STP Hello / MaxAge / FwdDelay | 2 | 20 / 15 |
