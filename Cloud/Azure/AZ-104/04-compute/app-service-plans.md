# Configure Azure App Service plans（プラン選定 / スケール設計）

> 本ノートは **“Configure Azure App Service plans”** モジュール準拠。**価格階層・OS・リージョン・スケール**をプランで決める、という発想が最重要。[5](https://learn.microsoft.com/en-us/shows/beginners-series-to-microsoft-graph/module-2-understand-the-role-of-azure-active-directory-with-microsoft-graph)

## 1. App Service plan の役割
- **App Service / Functions（消費プラン除く）**等が載る**共有コンピュート基盤**で、**OS（Windows/Linux）・リージョン・機能・上限・スケール**が**プランで決まる**。[5](https://learn.microsoft.com/en-us/shows/beginners-series-to-microsoft-graph/module-2-understand-the-role-of-azure-active-directory-with-microsoft-graph)

## 2. 価格階層（概念）
- **Free/Shared/Basic**＝開発・検証、**Standard/Premium**＝本番を想定（スロット・自動スケール・ネットワーク機能などの差）。[5](https://learn.microsoft.com/en-us/shows/beginners-series-to-microsoft-graph/module-2-understand-the-role-of-azure-active-directory-with-microsoft-graph)

## 3. スケール戦略
- **Scale up**：プランの**ティア変更**（より高機能・高性能へ）。[5](https://learn.microsoft.com/en-us/shows/beginners-series-to-microsoft-graph/module-2-understand-the-role-of-azure-active-directory-with-microsoft-graph)  
- **Scale out**：**インスタンス数**を増減（手動またはルールベース）。[5](https://learn.microsoft.com/en-us/shows/beginners-series-to-microsoft-graph/module-2-understand-the-role-of-azure-active-directory-with-microsoft-graph)

## 4. 試験チェック
- 「**プランが OS/Region/機能/上限/スケールを決める**」「**Scale up と Scale out の違い**」を 30 秒で説明できるか。[5](https://learn.microsoft.com/en-us/shows/beginners-series-to-microsoft-graph/module-2-understand-the-role-of-azure-active-directory-with-microsoft-graph)

### 参考
- モジュール：**Configure Azure App Service plans**（Official Learn）[5](https://learn.microsoft.com/en-us/shows/beginners-series-to-microsoft-graph/module-2-understand-the-role-of-azure-active-directory-with-microsoft-graph)