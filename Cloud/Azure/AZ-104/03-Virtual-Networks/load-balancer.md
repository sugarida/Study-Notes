# Intro to Azure Load Balancer（L4：TCP/UDP / Standard SKU 前提）

> 本ノートは **AZ‑104 VNet 学習パス**に含まれる LB 項目の要点を要約（個別モジュール本文取得不可のため**学習パス公式掲載**を根拠として整理）。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

## 1. 役割と前提
- **L4（TCP/UDP）** のロードバランシングを提供。**Standard SKU** 前提で設計（Public/Private、バックエンドプール/プローブ/ルールで構成）。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

## 2. 重要機能
- **Health Probe**（TCP/HTTP/HTTPS）でバックエンドの正常性を判定。  
- **LB ルール**でポート転送/セッション維持などを定義。  
- **HA Ports**：東西トラフィックで**全ポート分散**を可能にする特性。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

## 3. 使い分け（試験）
- **L4 が要件**（ポート/プロトコル単位、シンプルな分散）なら LB、**L7（URL/Host/ヘッダ/WAF）** が要るなら **Application Gateway**。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

### 参考
- 学習パス：**AZ‑104: Configure & manage virtual networks**（LB 掲載）[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)