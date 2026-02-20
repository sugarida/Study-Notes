# Configure Azure App Service（アプリ作成 / スロット / セキュリティ / 監視）

> 本ノートは **“Configure Azure App Service”** モジュール準拠。**スロット（スワップ） / ドメイン & TLS / バックアップ / App Insights** を短時間で復習。[6](https://www.linkedin.com/posts/nikhil-kamode_allow-users-to-reset-their-password-with-activity-7367178571972231168-EGqQ)

## 1. アプリ作成とデプロイ
- **Windows / Linux** を選び、**コード or コンテナ**をデプロイ（CI/CD 連携も可）。[6](https://www.linkedin.com/posts/nikhil-kamode_allow-users-to-reset-their-password-with-activity-7367178571972231168-EGqQ)

## 2. デプロイスロット（頻出）
- **Staging / Production** を**スワップ**可能。**スロット固有設定**や**トラフィック ルーティング**でローリスク展開を実現。[6](https://www.linkedin.com/posts/nikhil-kamode_allow-users-to-reset-their-password-with-activity-7367178571972231168-EGqQ)

## 3. セキュリティと公開設定
- **カスタムドメイン + TLS/SSL**、**認証/認可（Easy Auth）**、必要に応じてネットワーク制御（IP 制限 / Private Endpoint）。[6](https://www.linkedin.com/posts/nikhil-kamode_allow-users-to-reset-their-password-with-activity-7367178571972231168-EGqQ)

## 4. バックアップ / 監視
- **バックアップ/復元**を有効化し、アプリの**診断ログ**や **Application Insights** で監視。[6](https://www.linkedin.com/posts/nikhil-kamode_allow-users-to-reset-their-password-with-activity-7367178571972231168-EGqQ)

## 5. 試験チェック
- 「**スロットの意味（スワップ/トラフィック操作）**」「**ドメイン&証明書**」「**App Insights**」を 1 行で言えるか。[6](https://www.linkedin.com/posts/nikhil-kamode_allow-users-to-reset-their-password-with-activity-7367178571972231168-EGqQ)

### 参考
- モジュール：**Configure Azure App Service**（Official Learn）[6](https://www.linkedin.com/posts/nikhil-kamode_allow-users-to-reset-their-password-with-activity-7367178571972231168-EGqQ)