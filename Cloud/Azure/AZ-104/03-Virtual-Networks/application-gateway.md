# Intro to Azure Application Gateway（L7：HTTP(S) / WAF / ルーティング）

> 本ノートは **AZ‑104 VNet 学習パス**の App Gateway 項目の要点を整理（モジュール本文は学習パス掲載を根拠に要約）。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

## 1. 役割
- **L7（HTTP/HTTPS）** のアプリ LB。**WAF（OWASP ルール）**、**パス/ホストベース ルーティング**、**TLS 終端/エンドツーエンド** などを提供。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

## 2. 基本構成
- **リスナー → ルール → バックエンド** の連鎖で経路制御。**ヘルスプローブ**でバックエンド健全性を監視。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

## 3. 使い分け（LBとの比較）
- **URL ベースや WAF が必要**＝Application Gateway、**L4 で足りる**＝Load Balancer。試験では**要件の表現**に注意。[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

### 参考
- 学習パス：**AZ‑104: Configure & manage virtual networks**（AppGW 掲載）[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)