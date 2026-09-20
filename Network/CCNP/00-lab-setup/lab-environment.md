# ラボ環境の選定と構築 🧪

> **Phase 0：最優先タスク。** ここが動かないと「コマンドを打つ」シナリオが成立しない。
> 目標：**3 日以内に、ルータ 4 台 + スイッチ 2 台のトポロジが起動する状態**にする。

---

## 選択肢の比較

| 環境 | 費用 | L2機能(STP/EtherChannel) | 自動化(NETCONF等) | 推奨度 |
|------|------|------|------|------|
| **Cisco CML**（Modeling Labs） | 有償（個人向けライセンスあり／無償枠の有無は要確認） | ◎ IOSvL2 で可 | ◎ IOS-XE ノード | ★★★ 本命 |
| **EVE-NG Community** | 無償（イメージは別途入手要） | ◎ | ◎ | ★★★ 次点 |
| **GNS3** | 無償 | ○（L2は工夫が要る） | ○ | ★★ |
| **Packet Tracer** | 無償 | △ CCNA 範囲まで | × | ★ 補助のみ |
| **中古実機**（Catalyst 2960/3560, ISR 29xx 等） | 数千〜数万円 | ◎ 本物 | △ 古い IOS は非対応 | ★★ L2 用に併用 |
| **DevNet Sandbox** | 無償 | × | ◎ 実機 IOS-XE を API で叩ける | ★★★ Phase 6 必須 |

### 結論（推奨構成）
```
メイン : CML または EVE-NG （ルーティング・L2・トンネル全般）
補助   : DevNet Sandbox     （自動化：RESTCONF / NETCONF / Python）
任意   : 中古 Catalyst 2 台 （STP / EtherChannel を物理で体感したい場合）
```

> 💡 **Packet Tracer だけで CCNP に挑むのは非推奨。**
> BGP アトリビュート、VRF、MST の細部、NETCONF など、PT では再現できない領域が多い。

---

## 必要スペックの目安（CML / EVE-NG）

| 項目 | 最低 | 快適 |
|------|------|------|
| CPU | 4 コア（VT-x/AMD-V 必須） | 8 コア以上 |
| メモリ | 16 GB | 32 GB |
| ストレージ | SSD 100 GB | SSD 250 GB |

- ルータ 1 ノード ≒ 512MB〜1GB のメモリを食う想定で台数を決める
- ノート PC 1 台で回す場合は **同時起動 6〜8 ノード**を上限と考える

---

## 構築手順（EVE-NG Community の例）

```bash
# 1. ハイパーバイザ上に EVE-NG の OVA をデプロイ（VMware Workstation / ESXi / Proxmox）
#    ※ ネストした仮想化（Virtualize Intel VT-x/EPT）を必ず有効化する

# 2. 初期セットアップ（コンソールから）
#    - root パスワード / ホスト名 / DNS / 管理 IP を設定

# 3. イメージ配置（正規に入手したイメージのみを使用すること）
#    ルータ: /opt/unetlab/addons/qemu/csr1000vng-<ver>/
#    L2SW  : /opt/unetlab/addons/iol/bin/  （または IOSvL2 を qemu へ）

# 4. パーミッション修正（EVE-NG 定番作業）
/opt/unetlab/wrappers/unl_wrapper -a fixpermissions

# 5. ブラウザで http://<EVE-NGのIP>/ にアクセスしてログイン
```

> ⚠️ **IOS イメージは必ず正規のライセンス／契約に基づいて入手すること。**
> CML のライセンスには参照イメージが含まれる。ここをクリアにしておくのが一番安全。

---

## 端末（PC）側の準備

| ツール | 用途 |
|--------|------|
| **Tera Term / PuTTY / SecureCRT** | コンソール接続。ログ自動保存を必ず ON |
| **VS Code / Neovim** | コンフィグとノートの編集（このリポジトリ） |
| **Python 3.x** | Phase 6 の自動化（`ncclient`, `requests`, `netmiko`） |
| **Postman または curl** | RESTCONF を叩く |
| **Git** | 学習ログとコンフィグのバージョン管理 |

### ログを必ず残す設定（Tera Term）
```
設定 → その他の設定 → ログ
  [x] 自動的にログ採取を開始する
  ログファイル名: C:\ccnp-log\&h_&Y&M&D_&h&m.log
```
> 打ったコマンドと出力が全部残るので、**後から .md に貼るだけでノートが完成する**。

---

## Python 環境（Phase 6 用の先行準備）

```bash
python3 -m venv ~/ccnp-venv
source ~/ccnp-venv/bin/activate
pip install ncclient requests netmiko paramiko pyyaml xmltodict
pip list
```

---

## DevNet Always-On Sandbox（実機ゼロで自動化を練習）

Cisco DevNet は、誰でも使える IOS-XE のサンドボックスを公開している。
**ホスト名・認証情報・対応 API は変更されることがあるため、必ず DevNet の公式ページで最新の情報を確認すること。**

```bash
# 疎通確認の例（ホスト名・認証情報は公式ページの最新値に読み替える）
curl -k -u <user>:<pass> \
  https://<sandbox-host>/restconf/data/Cisco-IOS-XE-native:native/hostname \
  -H "Accept: application/yang-data+json"
```

期待される出力（例）:
```json
{
  "Cisco-IOS-XE-native:hostname": "CSR1kv"
}
```

> これが返ってきたら Phase 6 の準備は完了。

---

## Phase 0 の完了チェックリスト

- [ ] ハイパーバイザ上でラボ環境が起動する
- [ ] ルータ 4 台 + L2SW 2 台を同時起動できる
- [ ] コンソール接続でき、ログが自動保存される
- [ ] `base-topology.md` の初期コンフィグを流し込める
- [ ] 作ったトポロジを**保存・復元**できる（毎回作り直さない）
- [ ] Python 仮想環境が作れている
- [ ] DevNet Sandbox に 1 回アクセスできた

> ✅ 全部埋まったら Phase 1 へ。
