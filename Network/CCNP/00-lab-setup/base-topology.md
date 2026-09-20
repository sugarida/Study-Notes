# 共通トポロジと初期コンフィグ 🗺️

> 毎回ゼロからトポロジを作ると、**設定より配線に時間を使う**ことになる。
> この共通トポロジを 1 つ保存しておき、各ラボはここからの「差分」だけを行う。

---

## 共通トポロジ（Core Topology）

```
                    [R1]--------[R2]
                     |  \      /  |
                     |   \    /   |
                     |    \  /    |
                     |     \/     |
                     |     /\     |
                     |    /  \    |
                     |   /    \   |
                    [R3]--------[R4]
                     |            |
                  [SW1]========[SW2]   ← EtherChannel (Gi0/1-2)
                     |            |
                   [PC1]        [PC2]
```

### IP アドレッシング規則（迷わないための固定ルール）

| 用途 | 形式 | 例 |
|------|------|-----|
| ルータ間 P2P リンク | `10.<小さい方>.<大きい方>.<自番号>/30` | R1-R2 → 10.1.2.1 / 10.1.2.2 |
| Loopback0（Router-ID） | `<番号>.<番号>.<番号>.<番号>/32` | R1 → 1.1.1.1/32 |
| ユーザ VLAN | `192.168.<VLAN番号>.0/24` | VLAN10 → 192.168.10.0/24 |
| 管理 VLAN | `192.168.99.0/24` | SW1 → 192.168.99.11 |

> 📌 **Loopback = 機器番号** にしておくと、`show ip ospf neighbor` の Router-ID を見た瞬間に
> どの機器かが分かる。トラブルシュートの速度が段違いになる。

---

## 全機器共通の初期コンフィグ（テンプレ）

```cisco
enable
configure terminal
!
hostname R1
!
no ip domain-lookup
!
line console 0
 logging synchronous
 exec-timeout 0 0
!
line vty 0 4
 logging synchronous
 exec-timeout 0 0
 transport input ssh
 login local
!
username admin privilege 15 secret Ccnp12345
enable secret Ccnp12345
!
ip domain-name lab.local
crypto key generate rsa modulus 2048
ip ssh version 2
!
service timestamps debug datetime msec
service timestamps log datetime msec
!
interface Loopback0
 ip address 1.1.1.1 255.255.255.255
!
end
write memory
```

### 各コマンドの意味（暗記ポイント）

| コマンド | 効果 | なぜ必要か |
|----------|------|------------|
| `no ip domain-lookup` | 打ち間違いを DNS 解決しに行かない | タイポで 30 秒固まるのを防ぐ |
| `logging synchronous` | ログ出力で入力行が崩れない | debug 時に必須 |
| `exec-timeout 0 0` | セッションが切れない | ラボ限定。**本番では絶対にやらない** |
| `service timestamps debug datetime msec` | debug にミリ秒付き時刻 | 事象の前後関係が分かる |
| `crypto key generate rsa modulus 2048` | SSH 鍵生成 | これが無いと `transport input ssh` で入れない |

---

## L2 スイッチ側の初期コンフィグ

```cisco
hostname SW1
!
vlan 10
 name USERS
vlan 20
 name SERVERS
vlan 99
 name MGMT
!
interface range GigabitEthernet0/1 - 2
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,20,99
!
interface Vlan99
 ip address 192.168.99.11 255.255.255.0
 no shutdown
!
ip default-gateway 192.168.99.254
!
end
write memory
```

> ⚠️ `switchport trunk encapsulation dot1q` は、**ISL もサポートする機種でのみ必要**。
> IOSvL2 や新しい機種では不要（打つとエラーになる）。エラーが出たらそのまま `switchport mode trunk` へ。

---

## コンフィグの保存・復元（時間短縮の肝）

### 保存
```cisco
! 実行中コンフィグを確認
show running-config

! 起動コンフィグに保存
copy running-config startup-config
! もしくは
write memory
```

### ラボ間で状態をリセットしたいとき
```cisco
! 設定を初期化して再起動
write erase
reload
! → "System configuration has been modified. Save? [yes/no]:" には no
```

### PC 側にバックアップ（TFTP を使う場合）
```cisco
copy running-config tftp://192.168.99.100/R1-lab01.cfg
```

> 💡 **おすすめ：各ラボの完成コンフィグをこのリポジトリに貼る。**
> `show running-config` の結果をそのままラボ .md の末尾に置いておくと、
> 翌週の復習で「差分だけ」を確認できる。

---

## 疎通確認の定番セット

```cisco
! L1/L2
show ip interface brief
show interfaces status              ! スイッチ
show cdp neighbors detail
show lldp neighbors

! L3
show ip route
ping 10.1.2.2
ping 10.1.2.2 source Loopback0
traceroute 10.1.2.2

! 拡張 ping（MTU 問題の切り分けに必須）
ping
Protocol [ip]:
Target IP address: 10.1.2.2
Repeat count [5]: 100
Datagram size [100]: 1500
Timeout in seconds [2]:
Extended commands [n]: y
Source address or interface: Loopback0
Type of service [0]:
Set DF bit in IP header? [no]: yes
```

> 📌 **DF bit を立てた 1500 バイト ping** は、OSPF の MTU 不一致や
> GRE/IPsec のフラグメント問題を切り分ける最強の道具。ENARSI で効く。

---

## トポロジ保存のチェックリスト

- [ ] このトポロジを「base」という名前でラボ環境に保存した
- [ ] 各機器の初期コンフィグを流し込んで `write memory` した
- [ ] 全ルータ間で P2P リンクの ping が通る
- [ ] SW1-SW2 間のトランクが上がっている
- [ ] 保存したトポロジを一度閉じて、再度開いて復元できた
