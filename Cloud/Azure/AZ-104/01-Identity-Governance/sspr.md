# Self-Service Password Reset（SSPR）実装ガイド

> 「評価→実装→体験カスタマイズ」「ハイブリッドは Writeback」がコア。[10](https://learn.microsoft.com/en-us/training/paths/az-104-manage-virtual-networks/)

## 1. 目的と効果
- ヘルプデスク工数削減・UX 向上。ユーザー自身が**ロック解除／パスワード再設定**を実施できる。[10](https://learn.microsoft.com/en-us/training/paths/az-104-manage-virtual-networks/)

## 2. 前提
- **Entra ID P1 以上**での機能セットを把握（テナント要件／管理者ロール要件）。[10](https://learn.microsoft.com/en-us/training/paths/az-104-manage-virtual-networks/)

## 3. 実装の流れ（モジュール準拠）
1) **判断**：導入可否（ユーザー対象／セキュリティ要件）を評価。[10](https://learn.microsoft.com/en-us/training/paths/az-104-manage-virtual-networks/)  
2) **実装**：SSPR を有効化し、**認証方法**（数／種類／登録）を設定。[10](https://learn.microsoft.com/en-us/training/paths/az-104-manage-virtual-networks/)  
3) **体験カスタマイズ**：登録体験／エラーメッセージ／サポート導線を整える。[10](https://learn.microsoft.com/en-us/training/paths/az-104-manage-virtual-networks/)

## 4. ハイブリッド（AD DS 同期あり）
- **パスワード書き戻し（Writeback）**を Entra Connect とテナント側で有効化し、**オンプレ AD へも新パスワードを反映**させる。[11](https://learn.microsoft.com/en-us/training/modules/manage-identities-azure-active-directory/)

## 5. 運用の勘どころ
- **対象範囲はグループ単位**でロールアウト（段階展開）。管理者は常に 2 要素必須。**古い SSPR/MFA ポリシーは廃止予定 → Authentication methods ポリシーへ統合**。[12](https://learn.microsoft.com/en-us/training/modules/create-configure-manage-identities/)[13](https://www.youtube.com/watch?v=vYs2Fz9LmzU)
- **監査**：SSPR の**監査ログ／使用状況レポート**を定期レビュー。[12](https://learn.microsoft.com/en-us/training/modules/create-configure-manage-identities/)

## 参考
- モジュール：**Allow users to reset their password with SSPR**（Official Learn）[10](https://learn.microsoft.com/en-us/training/paths/az-104-manage-virtual-networks/)  
- チュートリアル：**Enable SSPR（GitHub: entra-docs）**（管理方法の移行注意を含む）[13](https://www.youtube.com/watch?v=vYs2Fz9LmzU)  
- 実装解説（Writeback 含む）：**Enable Microsoft Entra SSPR**（技術ブログ）[11](https://learn.microsoft.com/en-us/training/modules/manage-identities-azure-active-directory/)