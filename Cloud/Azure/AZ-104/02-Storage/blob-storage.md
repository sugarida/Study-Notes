# Configure Azure Blob Storage（階層・運用・ライフサイクル・レプリケーション）

> 本ノートは AZ‑104 の **“Configure Azure Blob Storage”** モジュールの要点を整理。**階層 / ライフサイクル / ORS（Object Replication）**が試験の核。[4](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)

## 1. 基本構造とアクセスモデル
- 階層：**アカウント → コンテナー → Blob**。コンテナーの公開レベル（Private/Blob/Container）を要件で選ぶ。[4](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)

## 2. アクセス階層（コスト最適化）
- **Hot / Cool / Archive** を理解。アクセス頻度・取り出し遅延・コストで適切に配置し、必要に応じて **アカウント/コンテナー/オブジェクト**単位で設定する。[4](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)

## 3. ライフサイクル管理（自動化）
- ルールベースで **階層移行（Hot→Cool→Archive）/削除** を自動化。ログやバックアップの保持・削除に有効。[4](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)

## 4. オブジェクト レプリケーション（Blob）
- 同一/異リージョンのストレージアカウント間で **非同期のオブジェクト複製**をポリシーで構成（対象コンテナー/プレフィックスを指定）。コスト/整合性要件を試算する。[4](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)

## 5. データ保護（誤削除/改ざん対策）
- **Soft delete / Versioning / Immutability（WORM）** の採用でヒューマンエラーに備える。[4](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)

## 6. 代表操作（試験で問われやすい）
- アクセス階層の**変更条件**・料金影響、**ライフサイクル ルール**の書式と適用範囲、**コンテナー公開レベル**の選び方を説明できる。[4](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)

## 7. ラボ（補助）
- **Lab 07 – Manage Azure Storage** では Blob コンテナーのセキュリティ/バージョン/Soft delete を一通り試せる。[2](https://learn.microsoft.com/en-us/training/modules/get-started-identity-access-labs/)

### 参考
- モジュール：**Configure Azure Blob Storage**（Official Learn）[4](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)  
- 公式ラボ：**Lab 07 – Manage Azure Storage**（MicrosoftLearning）[2](https://learn.microsoft.com/en-us/training/modules/get-started-identity-access-labs/)