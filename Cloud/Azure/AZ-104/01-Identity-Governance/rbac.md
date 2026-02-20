# Secure Azure resources with RBAC（最小権限アクセスの実装）

> 「**誰**に／**何**のロールを／**どこ**のスコープで」の 3 要素を正確に。[7](https://www.youtube.com/watch?v=cke_6ytCDds)

## 1. RBAC の基本構造（3 要素）
- **セキュリティプリンシパル**：ユーザー／グループ／サービスプリンシパル／マネージド ID。[8](https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/blob/master/Instructions/Labs/LAB_07-Manage_Azure_Storage.md?plain=1)
- **ロール定義**：内蔵ロール（Owner/Contributor/Reader など）と**カスタムロール**（`Actions/NotActions` を設計）。[8](https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/blob/master/Instructions/Labs/LAB_07-Manage_Azure_Storage.md?plain=1)
- **スコープ**：**Management Group → Subscription → RG → Resource**。上位スコープの権限は**継承**される。[7](https://www.youtube.com/watch?v=cke_6ytCDds)

## 2. 代表タスク（モジュール準拠）
- **自分／他者のアクセス確認**、**アクセス権の付与**、**アクティビティログで RBAC 変更の監査**。[7](https://www.youtube.com/watch?v=cke_6ytCDds)

## 3. ベストプラクティス
- **最小権限**：Owner の乱用禁止、必要時のみ。[8](https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/blob/master/Instructions/Labs/LAB_07-Manage_Azure_Storage.md?plain=1)
- **スコープは狭く**：RG/Resource 単位に絞り、MG/Subscription 直付けは最小化。[7](https://www.youtube.com/watch?v=cke_6ytCDds)
- **カスタムロール**：`Actions` と `NotActions` で**許可／除外**を明示。[8](https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/blob/master/Instructions/Labs/LAB_07-Manage_Azure_Storage.md?plain=1)

## 4. ディレクトリロールとの違い
- **Entra のディレクトリロール ≠ Azure RBAC**。前者はテナント管理、後者は Azure リソース管理（試験の頻出混同点）。[3](https://docs.azure.cn/en-us/role-based-access-control/)

## 5. 演習（公式ラボ）
- **Manage Subscriptions and RBAC**：MG 作成、内蔵ロール付与、カスタムロール作成、アクティビティログ監査まで一通り実施。[9](https://www.youtube.com/watch?v=EH_2cTrg5PM)

## 参考
- モジュール：**Secure your Azure resources with RBAC**（Official Learn）[7](https://www.youtube.com/watch?v=cke_6ytCDds)  
- Docs：**Azure RBAC documentation**（ロール／割当／カスタムロール）[8](https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/blob/master/Instructions/Labs/LAB_07-Manage_Azure_Storage.md?plain=1)  
- ラボ：**Manage Subscriptions and RBAC**（MicrosoftLearning）[9](https://www.youtube.com/watch?v=EH_2cTrg5PM)