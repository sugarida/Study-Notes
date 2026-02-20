# Create, configure, and manage identities（ユーザー／グループ／属性／ライセンス）

> 本ノートは AZ‑104 の「Create, configure, and manage identities」「Manage Entra identities」に準拠。試験で狙われる運用タスクを要点化。[2](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/)[3](https://docs.azure.cn/en-us/role-based-access-control/)

## 1. 何を管理するのか
- **ユーザー**：作成／更新／無効化／削除、属性の一括更新、ライセンス割当。[2](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/)
- **グループ**：セキュリティ／Microsoft 365、静的／動的、メンバーシップ管理。[2](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/)
- **ライセンス**：ユーザーまたはグループベースでのアサインと取り消し。[2](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/)
- **カスタムセキュリティ属性／自動プロビジョニング**：属性拡張と SaaS 連携時の自動作成・更新。[2](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/)

## 2. 自動化（PowerShell / Graph）
- PowerShell（Microsoft Graph/Entra）で**ユーザー・グループの CRUD** や**一括操作**を行う。試験では「どのツールで何ができるか」の把握が重要。[3](https://docs.azure.cn/en-us/role-based-access-control/)

## 3. ハイブリッド同期（AD DS → Entra）
- **Entra Connect** を用いてオンプレ AD DS のユーザー／グループを同期。同期元が**SoT（Single source of truth）**となる設計が一般的。[3](https://docs.azure.cn/en-us/role-based-access-control/)

## 4. よく出る落とし穴
- **ディレクトリロールと Azure RBAC の混同**（Identity 面のロールと、Azure リソース面のロールは別）。[3](https://docs.azure.cn/en-us/role-based-access-control/)
- 大量作成・更新は **スクリプト or ブループリント**で再現性を確保する設計が推奨（運用タスクの自動化視点）。[3](https://docs.azure.cn/en-us/role-based-access-control/)

## 5. チェックリスト
- ユーザー/グループ/ライセンスの**最小操作**を 60 秒で説明できるか。[2](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/)
- 同期の有無と**編集元**（オンプレ／クラウド）の線引きを定義できるか。[3](https://docs.azure.cn/en-us/role-based-access-control/)

## 参考
- モジュール：**Create, configure, and manage identities**（Official Learn）[2](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/)  
- モジュール：**Manage Microsoft Entra identities**（関連）[3](https://docs.azure.cn/en-us/role-based-access-control/)