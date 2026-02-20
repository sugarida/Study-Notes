# Intro to Azure Network Watcher（可視化 / 診断 / トラブルシュート）

> 本ノートは **AZ‑104 VNet 学習パス**の Network Watcher 項目の要点まとめ。**Connection monitor / NSG flow logs / Packet capture / IP flow verify** 等を押さえる。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

## 1. 代表機能
- **Connection monitor**：エンドツーエンドの接続性監視（到達性/遅延）。  
- **NSG flow logs**：NSG 経由トラフィックのログ化。  
- **Packet capture**：対象 VM でのパケットキャプチャ。  
- **IP flow verify / Next hop**：NSG/UDR 絡みの到達性を即時判定。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

## 2. 試験観点
- **「到達しない」系の切り分け順**を言語化：有効 NSG ルール → UDR（Next hop） → DNS → 実パケット（Packet capture）。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

### 参考
- 学習パス：**AZ‑104: Configure & manage virtual networks**（Network Watcher 掲載）[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)