# Configure Azure Storage security（SAS / 暗号化 / CMK / セキュリティ姿勢）

> 本ノートは AZ‑104 の **“Configure Azure Storage security”** モジュールをベースに、**SAS と暗号化**の要点を最短で復習できるように整理。[5](https://github.com/Azure/cloud-for-sovereignty-policy-portfolio)

## 1. SAS（Shared Access Signature）
- **SAS URI** による限定的アクセス委任：**有効期間 / 権限 / IP 範囲 / プロトコル（HTTPS） / スコープ（アカウント/サービス/ユーザー）** を設定して発行。**Stored Access Policy** で複数 SAS を集中管理。[5](https://github.com/Azure/cloud-for-sovereignty-policy-portfolio)

## 2. 暗号化（at rest / in transit）
- **SSE（Server‑Side Encryption）** は既定で有効（Microsoft‑managed keys）。規制・内部統制要件が厳しい場合は **CMK（Customer‑Managed Keys）** を採用（Key Vault で鍵を保管/ローテーション）。[5](https://github.com/Azure/cloud-for-sovereignty-policy-portfolio)

## 3. セキュリティ ベストプラクティス
- **SAS は最小権限・短期間・必要最小範囲**で発行。**Allow storage account key access** を無効化し、可能な限り **ID ベース（Entra）**に寄せる。**TLS v1.2 以上**を強制。[5](https://github.com/Azure/cloud-for-sovereignty-policy-portfolio)[6](https://www.microsoft.com/en-us/industry/blog/government/sovereignty/2024/04/24/streamline-controls-with-microsoft-cloud-for-sovereignty/)

## 4. 代表設定の要点
- **アカウントキーより SAS**、**SAS よりもマネージド ID**を優先（委任と失効のコントロール性）。**CMK** 採用時は Key Vault の可用性/権限設計もセットで検討。[5](https://github.com/Azure/cloud-for-sovereignty-policy-portfolio)

## 5. 学習/演習（ハンズオン）
- **Secure storage for Azure Files and Azure Blob Storage – ラボ**：LRS/コスト最小構成・secure transfer required・最小 TLS 1.2・キーアクセス無効化など、実運用で使う設定を短時間で一通り復習できる。[6](https://www.microsoft.com/en-us/industry/blog/government/sovereignty/2024/04/24/streamline-controls-with-microsoft-cloud-for-sovereignty/)

### 参考
- モジュール：**Configure Azure Storage security**（Official Learn）[5](https://github.com/Azure/cloud-for-sovereignty-policy-portfolio)  
- ガイド付きラボ：**Secure storage for Azure Files and Azure Blob Storage**（MicrosoftLearning）[6](https://www.microsoft.com/en-us/industry/blog/government/sovereignty/2024/04/24/streamline-controls-with-microsoft-cloud-for-sovereignty/)