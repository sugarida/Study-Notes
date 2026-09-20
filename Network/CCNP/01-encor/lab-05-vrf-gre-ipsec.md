# Lab 05：仮想化（VRF-Lite / GRE / IPsec / Overlay）🧱
**対象週：Week 13 / ENCOR Virtualization 領域（10%）**

---

## Part A：VRF-Lite（経路テーブルの分割）

> 1 台のルータの中に「独立したルーティングテーブル」を複数持たせる技術。
> MPLS を使わない版が VRF-Lite。

```cisco
! --- VRF 定義（IOS-XE の新構文）---
vrf definition CUSTOMER_A
 rd 65001:1
 address-family ipv4
 exit-address-family
!
vrf definition CUSTOMER_B
 rd 65001:2
 address-family ipv4
 exit-address-family
!
! --- インターフェースを VRF に所属させる ---
interface GigabitEthernet0/1
 vrf forwarding CUSTOMER_A
 ip address 192.168.100.1 255.255.255.0    ! ← VRF 割当後に IP を振る（順序注意）
!
interface GigabitEthernet0/2
 vrf forwarding CUSTOMER_B
 ip address 192.168.100.1 255.255.255.0    ! ★ 同じIPが共存できる = VRF の威力
```

> ⚠️ **`vrf forwarding` を後から入れると、そのインターフェースの IP 設定が消える。**
> 必ず「VRF 割当 → IP 設定」の順で打つ。

### VRF 内でのルーティング
```cisco
! 静的ルート
ip route vrf CUSTOMER_A 10.0.0.0 255.0.0.0 192.168.100.254

! OSPF（VRF 対応）
router ospf 10 vrf CUSTOMER_A
 router-id 1.1.1.10
 network 192.168.100.0 0.0.0.255 area 0
```

### 確認（VRF 指定を忘れると何も見えない）
```cisco
show vrf
show vrf detail
show ip route vrf CUSTOMER_A
show ip interface brief vrf CUSTOMER_A
ping vrf CUSTOMER_A 192.168.100.254
traceroute vrf CUSTOMER_A 192.168.100.254
telnet 192.168.100.254 /vrf CUSTOMER_A
```

> 🔥 **`show ip route` だけ打つと "グローバルテーブル" しか見えない。**
> VRF の経路が無いと焦るが、`show ip route vrf <名前>` で出る。試験でも実務でもハマる定番。

### 🔨 わざと壊す
| # | 壊し方 | 症状 |
|---|--------|------|
| 1 | `vrf forwarding` を IP 設定後に入れる | IP が消える |
| 2 | `ping` を VRF 指定なしで打つ | 到達しない（グローバルから出ようとする） |
| 3 | CUSTOMER_A から CUSTOMER_B へ ping | 到達しない = **正しく分離されている証拠** |

---

## Part B：GRE トンネル

```cisco
! --- R1 ---
interface Tunnel0
 ip address 172.16.0.1 255.255.255.252
 tunnel source GigabitEthernet0/0
 tunnel destination 203.0.113.2
 ! tunnel mode gre ip   ← デフォルトなので省略可
 ip mtu 1400
 ip tcp adjust-mss 1360

! --- R2 ---
interface Tunnel0
 ip address 172.16.0.2 255.255.255.252
 tunnel source GigabitEthernet0/0
 tunnel destination 203.0.113.1
 ip mtu 1400
 ip tcp adjust-mss 1360
```

### 確認
```cisco
show interfaces Tunnel0
show ip interface brief | include Tunnel
ping 172.16.0.2
```

### GRE のポイント
- **GRE ヘッダ 24 バイト**（GRE 4 + 新IPヘッダ 20）のオーバーヘッド
- → MTU 1500 の回線では **実効 1476**。`ip mtu 1400` + `ip tcp adjust-mss 1360` が定番の対処
- **GRE 自体には暗号化が無い**（だから IPsec と組み合わせる）
- マルチキャストを通せる → **GRE 越しに OSPF/EIGRP が動かせる**（IPsec 単体では不可）

### 🔨 わざと壊す（Recursive Routing）
```cisco
! トンネル経由の経路でトンネル宛先を学習させる
router ospf 1
 network 203.0.113.0 0.0.0.255 area 0   ! ← トンネル宛先を IGP に載せる
```
```
%TUN-5-RECURDOWN: Tunnel0 temporarily disabled due to recursive routing
```
> 🔥 **トンネルの宛先アドレスをトンネル経由で学習すると、トンネルが自分自身を必要とする
> ループに陥って Down する。** ENARSI でも問われる古典的トラブル。
> 対処：トンネル宛先は必ず **トンネルの外側（アンダーレイ）の経路**で到達させる。

---

## Part C：IPsec（サイト間 VPN）

```cisco
! --- Phase 1 : IKEv2 プロポーザル/ポリシー ---
crypto ikev2 proposal PROP1
 encryption aes-cbc-256
 integrity sha256
 group 14
!
crypto ikev2 policy POL1
 proposal PROP1
!
crypto ikev2 keyring KEY1
 peer R2
  address 203.0.113.2
  pre-shared-key CcnpLabSecret
!
crypto ikev2 profile PROF1
 match identity remote address 203.0.113.2 255.255.255.255
 authentication local pre-share
 authentication remote pre-share
 keyring local KEY1
!
! --- Phase 2 : トランスフォームセット + プロファイル ---
crypto ipsec transform-set TS1 esp-aes 256 esp-sha256-hmac
 mode transport            ! GRE over IPsec なら transport、純IPsecなら tunnel
!
crypto ipsec profile IPSEC-PROF
 set transform-set TS1
 set ikev2-profile PROF1
!
! --- GRE トンネルに適用（GRE over IPsec）---
interface Tunnel0
 tunnel protection ipsec profile IPSEC-PROF
```

### 確認
```cisco
show crypto ikev2 sa
show crypto ipsec sa
show crypto session
show crypto session detail
debug crypto ikev2
debug crypto ipsec
```

`show crypto ipsec sa` で見る箇所:
```
    #pkts encaps: 120, #pkts encrypt: 120, #pkts digest: 120
    #pkts decaps: 118, #pkts decrypt: 118, #pkts verify: 118
```
> 📌 **encrypt は増えるが decrypt が増えない → 戻りのトラフィックが来ていない**
> （相手側の設定 or 経路 or NAT/FW を疑う）。切り分けの決定打。

### 暗記ポイント
| フェーズ | 目的 | 使うもの |
|---------|------|----------|
| IKE Phase 1 | 管理用のセキュアチャネル確立 | DH グループ、認証（PSK/証明書）、UDP 500 |
| IKE Phase 2 | 実データ用の SA 確立 | トランスフォームセット、ESP/AH |

| プロトコル | 暗号化 | 完全性 | 備考 |
|-----------|--------|--------|------|
| **ESP**（プロトコル 50） | ✅ | ✅ | 実運用はこちら |
| **AH**（プロトコル 51） | ❌ | ✅ | NAT 越え不可 |

- NAT 越えが必要な場合は **NAT-T（UDP 4500）**
- モード：**Tunnel（元のIPヘッダごと包む）/ Transport（ペイロードのみ）**

---

## Part D：Overlay の概念（VXLAN / LISP）※座学

コマンドで触れない領域だが ENCOR では出る。**自分で図を描いて理解する。**

### VXLAN
```
[VM-A]--(VLAN10)--[VTEP1] ===== IP網(Underlay) ===== [VTEP2]--(VLAN10)--[VM-B]
                    ↑  VXLAN カプセル化（UDP 4789）          ↑
                  VNI 10010                              VNI 10010
```
| 項目 | 値 |
|------|-----|
| カプセル化 | MAC-in-UDP |
| UDP ポート | **4789** |
| 識別子 | **VNI（24bit）→ 約 1,600 万**（VLAN の 4094 を大幅に超える） |
| 端点 | **VTEP**（VXLAN Tunnel End Point） |
| オーバーヘッド | 50 バイト（要 MTU 拡張：9000 推奨） |

### LISP（SD-Access のコントロールプレーン）
| 用語 | 役割 |
|------|------|
| **EID** | Endpoint Identifier（端末の識別子＝"誰か"） |
| **RLOC** | Routing Locator（場所の識別子＝"どこか"） |
| **MS/MR** | Map-Server / Map-Resolver（EID↔RLOC の対応を管理） |
| **ITR / ETR** | 入口 / 出口のトンネルルータ |

> 🔥 **LISP の本質は「アイデンティティ（誰）とロケーション（どこ）の分離」。**
> これが SD-Access で端末が移動しても IP が変わらない仕組みの根拠。

### SD-Access のコンポーネント対応
| レイヤ | 役割 | 実体 |
|--------|------|------|
| Underlay | 物理の IP 到達性 | IS-IS / OSPF |
| Overlay（Fabric） | 論理のセグメント | VXLAN |
| Control Plane | EID↔RLOC 解決 | **LISP** |
| Policy | グループベースのポリシー | **SGT / TrustSec（Cisco ISE）** |
| Management | 自動化・可視化 | Cisco DNA Center / Catalyst Center |

---

## ✅ 卒業条件
- [ ] VRF を 2 つ作り、**同じ IP が共存できる**ことを確認した
- [ ] `show ip route vrf` を使わないと見えないことを体感した
- [ ] GRE トンネルを構築し、OSPF をトンネル越しに動かした
- [ ] Recursive Routing をわざと発生させ、ログを見た
- [ ] GRE over IPsec を構築し、`show crypto ipsec sa` の encaps/decaps を確認した
- [ ] VXLAN と LISP の図を**自分で描いた**
