# Lab 06：無線（Wireless）📡
**対象週：Week 14 / ENCOR Infrastructure の一部**

> **コマンドラボが組めない分野。** ここは「図を描く」「用語を整理する」が学習法になる。
> ただし丸暗記に逃げず、**「有線とどこが違うか」**の観点で理解する。

---

## 1. AP の動作モード

| モード | 制御 | データ転送 | 用途 |
|--------|------|-----------|------|
| **Autonomous**（自律） | AP 単体 | AP がローカルで転送 | 小規模・WLC なし |
| **Lightweight**（集中制御） | **WLC** | CAPWAP で WLC へ（Local モード） | 一般的な企業 |
| **FlexConnect** | WLC | **拠点内でローカルスイッチング** | WAN 越しの支店 |
| **Cloud-based**（Meraki 等） | クラウド | ローカル | クラウド管理 |
| **Embedded / EWC** | AP 内蔵 WLC | ローカル | 小規模でコントローラ不要 |

> 🔥 **FlexConnect の本質：制御は WLC、データは拠点内で折り返す。**
> WAN が切れても支店内の通信は継続できる（Local モードは WLC 経由なので止まる）。

### AP の特殊モード
| モード | 用途 |
|--------|------|
| Monitor | 電波監視・不正AP検出（クライアント収容しない） |
| Sniffer | パケットキャプチャ専用 |
| Rogue Detector | 不正AP検出専用 |
| Bridge / Mesh | 拠点間の無線ブリッジ |
| SE-Connect | スペクトラム解析 |

---

## 2. CAPWAP（AP と WLC の通信）

```
[AP] ===== CAPWAP Control (UDP 5246) ===== [WLC]
     ===== CAPWAP Data    (UDP 5247) =====
```
| 項目 | 内容 |
|------|------|
| Control ポート | **UDP 5246**（DTLS で暗号化：既定で有効） |
| Data ポート | **UDP 5247**（DTLS は任意） |
| 前身 | LWAPP |
| L2/L3 | **CAPWAP は L3（IP 上）で動く** → AP と WLC が別サブネットでよい |

### AP が WLC を見つける順序（AP Discovery / Join）
```
1. 既に記憶している WLC（Primed / 前回の接続先）
2. DHCP Option 43
3. DNS（CISCO-CAPWAP-CONTROLLER.<ローカルドメイン>）
4. サブネットブロードキャスト（同一 L2 の場合）
→ Discovery Request → Discovery Response → Join Request → Join Response
```
> 📌 **Option 43 と DNS の 2 つは必ず覚える。**「AP が WLC に Join しない」の定番原因。

---

## 3. WLC のポートとインターフェース

| 名称 | 役割 |
|------|------|
| **Management Interface** | WLC の管理、AP の Join 先（in-band） |
| **Service Port** | 帯域外管理専用（out-of-band、ルーティング不可） |
| **Dynamic Interface** | WLAN を VLAN にマッピング（ユーザトラフィック） |
| **Virtual Interface** | DHCP リレー、Web 認証用の仮想 IP（例 192.0.2.1） |
| **AP Manager** | AP との CAPWAP 終端（新しい機種では Management に統合） |

| ポート種別 | 役割 |
|-----------|------|
| Distribution System Port | 有線側への接続（トランク） |
| Console Port | CLI |
| Redundancy Port | HA ペア間の同期 |

> **WLAN（SSID）→ Dynamic Interface → VLAN** の紐付けが設定の中心。

---

## 4. 無線 LAN の基礎（出題される物理層）

| 規格 | 世代名 | 周波数 | 備考 |
|------|--------|--------|------|
| 802.11a | — | 5GHz | |
| 802.11b/g | — | 2.4GHz | |
| 802.11n | Wi-Fi 4 | 2.4/5GHz | MIMO |
| 802.11ac | Wi-Fi 5 | **5GHz のみ** | MU-MIMO(下り) |
| 802.11ax | Wi-Fi 6 / 6E | 2.4/5/(6)GHz | OFDMA、BSS Coloring |

### チャネル設計（頻出）
- **2.4GHz：重ならないチャネルは 1 / 6 / 11 の 3 つだけ**
- 5GHz：多数のチャネルが使える（DFS チャネルはレーダー検知で退避が必要）
- **同一チャネルの隣接 AP は互いに干渉する（Co-Channel Interference）**

### RF 用語
| 用語 | 意味 |
|------|------|
| **RSSI** | 受信信号強度（dBm、負の値。-60 は -70 より良い） |
| **SNR** | 信号とノイズの比（dB、大きいほど良い。25dB 以上が目安） |
| **EIRP** | 実効等方放射電力 = 送信電力 - ケーブル損失 + アンテナ利得 |
| dBm | 1mW 基準の絶対値 |
| **3dB 則** | +3dB で電力 2 倍、-3dB で半分 |

---

## 5. 無線セキュリティ

| 方式 | 暗号 | 認証 | 備考 |
|------|------|------|------|
| WEP | RC4 | — | **使用禁止**（解読可能） |
| WPA | TKIP | PSK / 802.1X | 非推奨 |
| **WPA2** | **AES-CCMP** | PSK / 802.1X | 現行の標準 |
| **WPA3** | **AES-GCMP** | **SAE** / 802.1X | PSK を SAE に置換、PMF 必須 |

### 802.1X（エンタープライズ認証）の 3 者
```
[Supplicant]  ←EAPOL→  [Authenticator]  ←RADIUS→  [Authentication Server]
 (クライアント)            (AP/WLC/SW)              (ISE / RADIUS)
```
| 役割 | 実体 |
|------|------|
| Supplicant | PC の 802.1X クライアント |
| Authenticator | AP / WLC / スイッチ（ポートを開閉する門番） |
| Authentication Server | Cisco ISE などの RADIUS サーバ |

- Supplicant ↔ Authenticator：**EAPOL**（EAP over LAN）
- Authenticator ↔ Server：**RADIUS**（UDP 1812/1813）

### EAP の種類
| 方式 | クライアント証明書 |
|------|------------------|
| EAP-TLS | **必要**（最も安全） |
| PEAP | 不要（サーバ証明書 + ID/PW） |
| EAP-FAST | 不要（PAC を使用、Cisco 発） |

---

## 6. 有線側の設定（ここだけはコマンドで触れる）

```cisco
! --- AP を接続するスイッチポート（Local モードの Lightweight AP）---
interface GigabitEthernet1/0/10
 description ** Lightweight AP **
 switchport mode access
 switchport access vlan 50            ! AP 管理VLAN
 spanning-tree portfast
!
! --- FlexConnect や Autonomous AP の場合はトランク ---
interface GigabitEthernet1/0/11
 description ** FlexConnect AP **
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk native vlan 50
 switchport trunk allowed vlan 50,10,20
!
! --- PoE 確認 ---
show power inline
show power inline GigabitEthernet1/0/10 detail
!
! --- AP を見つける ---
show cdp neighbors detail
show lldp neighbors detail
show mac address-table interface GigabitEthernet1/0/10
```

> 🔥 **Local モードの AP はアクセスポート、FlexConnect / Autonomous はトランク。**
> ここを間違えると AP は上がるがクライアントが通信できない。頻出。

---

## 7. トラブルシュート観点（暗記）

| 症状 | 疑うところ |
|------|-----------|
| AP が WLC に Join しない | Option 43 / DNS / 時刻(証明書) / AP 管理VLAN の疎通 |
| AP は上がるがクライアントが繋がらない | WLAN↔Dynamic Interface↔VLAN のマッピング |
| 認証だけ失敗する | RADIUS 共有シークレット / ISE 側のポリシー |
| 繋がるが遅い・切れる | チャネル干渉（同一チャネル） / RSSI・SNR 不足 / AP 密度 |
| PoE が入らない | 電力クラスとスイッチの供給能力 → `show power inline` |
| AP の証明書エラーで Join 失敗 | **WLC/AP の時刻ずれ（NTP）** |

---

## ✅ 卒業条件（コマンドが無い分、成果物で判定）
- [ ] AP → CAPWAP → WLC → 有線の経路図を**自分で描いた**
- [ ] Local モードと FlexConnect のデータ経路の違いを図で説明できる
- [ ] AP Discovery の 4 つの方法を言える
- [ ] WLC の 5 種類のインターフェースの役割を言える
- [ ] 802.1X の 3 者と使用プロトコルを図で描ける
- [ ] 2.4GHz の非重複チャネルを即答できる
