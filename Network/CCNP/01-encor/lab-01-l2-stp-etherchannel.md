# Lab 01：L2 基盤（VLAN / STP / EtherChannel）🔀
**対象週：Week 1-3 / ENCOR Infrastructure 領域**

> CCNA の復習に見えるが、CCNP では **MST・RSTP の内部動作**と
> **EtherChannel のネゴシエーション条件**が問われる。ここは落とせない。

---

## トポロジ

```
      [SW1]=====Po1(Gi0/1-2)=====[SW2]
        |                          |
      Gi0/3                      Gi0/3
        |                          |
      [SW3]----------Gi0/1--------(  )
```
VLAN: 10(USERS) / 20(SERVERS) / 99(MGMT)

---

## Step 1：VLAN とトランク

```cisco
! --- SW1 ---
vlan 10
 name USERS
vlan 20
 name SERVERS
vlan 99
 name MGMT
!
interface range GigabitEthernet0/1 - 3
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,20,99
 switchport trunk native vlan 99
!
interface GigabitEthernet0/10
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
 spanning-tree bpduguard enable
```

### 確認
```cisco
show vlan brief
show interfaces trunk
show interfaces GigabitEthernet0/1 switchport
```

`show interfaces trunk` の見るべき行:
```
Port        Mode         Encapsulation  Status        Native vlan
Gi0/1       on           802.1q         trunking      99

Port        Vlans allowed on trunk
Gi0/1       10,20,99

Port        Vlans allowed and active in management domain
Gi0/1       10,20,99

Port        Vlans in spanning tree forwarding state and not pruned
Gi0/1       10,20,99
```

> 📌 下 2 つのリストに VLAN が無ければ、**allowed には入っているが流れていない**。
> 「VLAN が存在しない」か「STP でブロックされている」のどちらか。

---

## Step 2：RSTP（Rapid PVST+）

```cisco
! --- 全スイッチ ---
spanning-tree mode rapid-pvst
!
! --- SW1 を VLAN10/99 のルート、SW2 を VLAN20 のルートにする ---
! SW1
spanning-tree vlan 10,99 root primary
spanning-tree vlan 20 root secondary
! SW2
spanning-tree vlan 20 root primary
spanning-tree vlan 10,99 root secondary
```

`root primary` は内部的に priority を下げるマクロ。実際の値を確認する:
```cisco
show spanning-tree vlan 10
show spanning-tree root
show spanning-tree summary
```

出力の読み方:
```
VLAN0010
  Root ID    Priority    24586          ← 24576 + VLAN ID(10) = 拡張システムID
             Address     0c11.2233.4400
             This bridge is the root     ← 自分がルート
             Hello Time 2  Max Age 20  Forward Delay 15

Interface        Role Sts Cost      Prio.Nbr Type
Gi0/1            Desg FWD 4         128.1    P2p
Gi0/3            Desg FWD 4         128.3    P2p
```

### 暗記ポイント：ポート役割とステート
| 役割 | 意味 |
|------|------|
| Root(Root Port) | ルートブリッジへの最良経路（各非ルートに 1 つ） |
| Desg(Designated) | そのセグメントで転送を担当 |
| Altn(Alternate) | ルートポートの代替（BPDU を受信中・ブロック） |
| Back(Backup) | 同一セグメント上の代替（共有メディアのみ） |

| ステート | RSTP |
|----------|------|
| Discarding | Blocking + Listening を統合 |
| Learning | MAC 学習のみ |
| Forwarding | 転送 |

### ルートブリッジ選出順（暗記必須）
```
1. 最小のブリッジ優先度（Priority + 拡張システムID）
2. 同値なら 最小の MAC アドレス
```
### ルートポート選出順（暗記必須）
```
1. 最小のルートパスコスト
2. 送信元ブリッジID が最小
3. 送信元ポートID(Priority.Number) が最小
4. 受信ポートID が最小
```

---

## Step 3：MST（Multiple Spanning Tree）

**MST は「VLAN をインスタンスに束ねる」技術。** VLAN が 100 個あっても STP は 2 つ、が作れる。

```cisco
! --- 全スイッチで同一設定にする（ここがキモ） ---
spanning-tree mode mst
!
spanning-tree mst configuration
 name CCNP-LAB
 revision 1
 instance 1 vlan 10,99
 instance 2 vlan 20
exit
!
! SW1 を インスタンス1 のルート、SW2 を インスタンス2 のルートに
! SW1
spanning-tree mst 1 root primary
spanning-tree mst 2 root secondary
! SW2
spanning-tree mst 2 root primary
spanning-tree mst 1 root secondary
```

### 確認
```cisco
show spanning-tree mst configuration
show spanning-tree mst
show spanning-tree mst 1
show spanning-tree mst configuration digest
```

`show spanning-tree mst configuration` の出力:
```
Name      [CCNP-LAB]
Revision  1     Instances configured 3
Instance  Vlans mapped
--------  ---------------------------------------
0         1-9,11-19,21-98,100-4094
1         10,99
2         20
```

> 🔥 **最重要：MST リージョンが同一と判定される条件（3つ全部一致）**
> 1. **リージョン名**（`name`）
> 2. **リビジョン番号**（`revision`）
> 3. **VLAN → インスタンスのマッピング**
>
> 1 文字でも違うと**別リージョン扱い**になり、リージョン間は
> **IST(インスタンス0)** だけで接続される＝設計意図どおりに冗長化されない。
> `show spanning-tree mst configuration digest` のダイジェスト値が一致するかで確認できる。

---

## Step 4：EtherChannel

```cisco
! --- SW1（LACP / active） ---
interface range GigabitEthernet0/1 - 2
 shutdown
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,20,99
 channel-group 1 mode active
 no shutdown
!
interface Port-channel1
 switchport mode trunk
 switchport trunk allowed vlan 10,20,99

! --- SW2（LACP / passive でも可） ---
interface range GigabitEthernet0/1 - 2
 channel-group 1 mode active
```

### ネゴシエーションモードの組み合わせ（暗記必須）

| プロトコル | モード | 相手が active | passive | desirable | auto | on |
|---|---|---|---|---|---|---|
| **LACP**(業界標準 802.3ad) | active | ✅ | ✅ | ❌ | ❌ | ❌ |
| | passive | ✅ | ❌(両方passiveは不可) | ❌ | ❌ | ❌ |
| **PAgP**(Cisco独自) | desirable | ❌ | ❌ | ✅ | ✅ | ❌ |
| | auto | ❌ | ❌ | ✅ | ❌(両方autoは不可) | ❌ |
| **静的** | on | ❌ | ❌ | ❌ | ❌ | ✅ |

> 📌 **LACP と PAgP の混在は不可。`on` と `active` の組み合わせも不可。**
> 「両方受け身（passive/passive, auto/auto）」も束ならない。

### 束ねるための一致条件（不一致だと suspended）
- 速度 / デュプレックス
- スイッチポートモード（access / trunk）
- 許可 VLAN と ネイティブ VLAN
- STP のコストと優先度（ポート単位）

### 確認
```cisco
show etherchannel summary
show etherchannel 1 port-channel
show etherchannel load-balance
show lacp neighbor
show lacp 1 internal
show pagp neighbor
```

`show etherchannel summary` の読み方:
```
Flags:  D - down        P - bundled in port-channel
        I - stand-alone s - suspended
        U - in use      f - failed to allocate aggregator

Group  Port-channel  Protocol    Ports
------+-------------+-----------+----------------------------
1      Po1(SU)         LACP      Gi0/1(P)  Gi0/2(P)
```
| 記号 | 意味 | 対処 |
|------|------|------|
| `(SU)` | Layer2 + 使用中 = **正常** | — |
| `(SD)` | down | 物理リンク / shutdown を確認 |
| `(P)` | メンバとして束ねられている = 正常 | — |
| `(I)` | stand-alone（束ねられず単独動作） | **相手のモード不一致を疑う** |
| `(s)` | suspended | **設定不一致（VLAN/速度/モード）を疑う** |

### ロードバランス方式
```cisco
port-channel load-balance src-dst-ip
```
> デフォルトは機種依存（`src-mac` など）。**フローが偏る場合は src-dst-ip / src-dst-port に変える**。

---

## 🔨 わざと壊す（Lv.3 トレーニング）

| # | 壊し方 | 期待される症状 | 確認コマンド |
|---|--------|----------------|--------------|
| 1 | SW2 の MST `revision` を 2 に変える | リージョンが分断、Po はつながるが STP トポロジが変わる | `show spanning-tree mst configuration digest` |
| 2 | SW2 側だけ `channel-group 1 mode on` | ポートが `(I)` or `(s)` になる | `show etherchannel summary` |
| 3 | SW1 の Gi0/1 だけ allowed vlan を変える | `(s)` suspended | `show etherchannel summary`, `show interfaces trunk` |
| 4 | 片側のネイティブ VLAN を 1 に戻す | Native VLAN mismatch のログ | `show log`, `show cdp neighbors detail` |
| 5 | アクセスポートに BPDU を流す（別SWを接続） | `err-disabled` になる | `show interfaces status err-disabled` |

### err-disabled からの復旧
```cisco
! 原因を確認
show interfaces status err-disabled
show errdisable recovery

! 手動復旧
interface GigabitEthernet0/10
 shutdown
 no shutdown

! 自動復旧を有効化（ラボ用）
errdisable recovery cause bpduguard
errdisable recovery interval 60
```

---

## ✅ 卒業条件

- [ ] 白紙から VLAN + トランク + Rapid PVST+ を 5 分で組める
- [ ] MST リージョン一致の 3 条件を**何も見ずに言える**
- [ ] LACP / PAgP のモード組み合わせ表を**書き出せる**
- [ ] `(s)` と `(I)` の違いを説明でき、原因を切り分けられる
- [ ] 上の「壊し方」5 パターンを全部再現した
