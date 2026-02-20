# Network Watcher Tools（接続性・到達性・パケットレベルの監視）

> 本ノートは AZ‑104 の **VNet 学習パスに含まれる Network Watcher モジュール**の要点整理版。  
> 「到達しないときの切り分け」が試験で頻出。[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

---

## 1. Connection Monitor
- VM ⇔ VM / VM ⇔ Public Endpoint などのエンドツーエンド接続性を継続的に監視  
- 遅延・到達不可の原因を可視化  
- 複雑なネットワーク環境でトラブルシュートに有効  
[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

---

## 2. NSG Flow Logs
- NSG の許可/拒否トラフィックをログ化  
- Storage Account に保存、Traffic Analytics と組み合わせる  
- 実際の通信パターンを可視化（セキュリティ／運用で重要）  
[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

---

## 3. Packet Capture
- 対象 VM 上でパケットをキャプチャ  
- 特定のポート／方向性でフィルタ可能  
- アプリケーション通信の詳細調査に使用  
[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

---

## 4. IP Flow Verify
- **特定の通信が NSG によって許可されるか／拒否されるかを即判定**  
- 到達しないときの最速トラブルシュート  
[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

---

## 5. Next Hop
- ある宛先へのトラフィックが **次に向かう先のルート情報（NVA / Internet / VNet / VNet Peering）** を表示  
- **UDR の誤り検出**に最適  
[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

---

## 6. トラブルシュートの鉄板手順（試験向け）
1. **Effective NSG Rules**（許可/拒否）  
2. **Next Hop**（UDR の影響）  
3. **DNS 解決確認**  
4. **Packet Capture**（最終手段）  
[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

---

## 参考
- 学習パス：**Network Watcher – 診断機能（AZ‑104）** [1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)