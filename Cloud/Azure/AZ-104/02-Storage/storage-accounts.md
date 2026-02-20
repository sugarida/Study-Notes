# Configure storage accounts（ストレージアカウント設計と構成）

> 本ノートは AZ‑104 の **“Configure storage accounts”** モジュールの要点を、試験と実務の観点で圧縮したものです。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)

## 1. ストレージアカウントの役割
- Blob / Files / Queues / Tables など **Azure Storage サービスの境界**であり、**課金・セキュリティ・ネットワーク**設定の単位となる。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)

## 2. 種類と選定
- **GPv2（General‑purpose v2）**：まずはこれが既定。Blob/Files を含む主要機能に対応。Premium が不要なら GPv2 を選定。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)
- **Premium 系**：高スループット/低遅延が要る場合（例：**FileStorage（Premium File Shares）**、Premium Block Blobs など）を選ぶ。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)

## 3. 冗長化（レプリケーション）
- **LRS / ZRS / GRS / RA‑GRS / GZRS / RA‑GZRS** の中から、**RPO/RTO とコスト**で選択する（RA = 既読可のセカンダリ）。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)

## 4. ネットワークとエンドポイント
- **Public network access** の可否・範囲、**Storage firewall & virtual networks**、**Private Endpoint** などで閉域化・制御を実装する。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)

## 5. データ保護と暗号化
- **Soft delete / Versioning** 等の Data protection を用途に合わせて有効化。暗号化は既定でサーバー側（SSE）実施、必要なら **Customer‑Managed Keys（CMK）** へ拡張。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)

## 6. 代表手順（Portal）
1) **Create a storage account**（GPv2 / 冗長化 / ネットワーク制御）→  
2) **Data protection**（Soft delete / Versioning）→  
3) **Encryption**（MMK → 必要なら CMK）→  
4) **Endpoint/Tools**（Storage Browser/Storage Explorer）で確認。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)

## 7. 演習（公式ラボ）
- **Lab 07: Manage Azure Storage**：G*RS・Public access 無効化・Blob/Files のセキュア設定などを一通り実施。[2](https://learn.microsoft.com/en-us/training/modules/get-started-identity-access-labs/)[3](https://www.youtube.com/watch?v=WGQCmCeV8ec)

## 8. チェックポイント（試験向け）
- 「**まず GPv2、必要なら Premium**」を言い切れるか。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)
- 冗長化の**違いを 1 行で**：LRS（1DC）/ZRS（3AZ）/GRS（地域間）/RA‑*（読み取り可）。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)
- Public access / Firewall / Private Endpoint の**使い分け**を説明できるか。[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)

### 参考
- モジュール：**Configure storage accounts**（Official Learn）[1](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)  
- 公式ラボ：**Lab 07 – Manage Azure Storage**（MicrosoftLearning）[2](https://learn.microsoft.com/en-us/training/modules/get-started-identity-access-labs/)[3](https://www.youtube.com/watch?v=WGQCmCeV8ec)