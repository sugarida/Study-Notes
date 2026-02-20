# Configure Azure Container Instances（ACI：VM/オーケストレーター不要で最速）

> 本ノートは **“Configure Azure Container Instances”** モジュールと公式ラボの要点を要約。**コンテナーグループ / VNet 統合 / Public FQDN** を押さえる。[7](https://qiita.com/LimeSML/items/28e11c07138630234b10)[8](https://bing.com/search?q=AZ-104+study+guide+Microsoft+Learn+AZ-104T00+summary)

## 1. いつ ACI を使うか
- **VM 管理やオーケストレーターなし**で**最短でコンテナ実行**したいとき（検証 / バッチ / 一時的ワークロード等）。[7](https://qiita.com/LimeSML/items/28e11c07138630234b10)

## 2. 主要機能
- **コンテナーグループ**（同一ホスト・共有ライフサイクル/ネットワーク/ボリューム）。[7](https://qiita.com/LimeSML/items/28e11c07138630234b10)  
- **FQDN / Public IP** で外部公開も可能、**VNet へ統合**して内部通信にも対応。[7](https://qiita.com/LimeSML/items/28e11c07138630234b10)  
- **Azure Files マウント**や **Linux/Windows** サポートなど実務に必要な要素を備える。[7](https://qiita.com/LimeSML/items/28e11c07138630234b10)

## 3. すぐ試す（公式ラボ）
- Portal → **Container instances** → **Quickstart image**（`mcr.microsoft.com/azuredocs/aci-helloworld:latest`）でデプロイし、**DNS 名**で疎通確認。[8](https://bing.com/search?q=AZ-104+study+guide+Microsoft+Learn+AZ-104T00+summary)

## 4. サービス使い分け（頻出）
- **最速実行**＝ACI、**Web 運用 + スロット/CI**＝App Service、**大規模/複合**＝AKS。[7](https://qiita.com/LimeSML/items/28e11c07138630234b10)[9](https://www.pax8nebula.com/m/7b5c0f1cbf3ef349/original/AZ-104-Study-Guide.pdf)

### 参考
- モジュール：**Configure Azure Container Instances**（Official Learn）[7](https://qiita.com/LimeSML/items/28e11c07138630234b10)  
- 公式ラボ：**Lab 09b – Implement Azure Container Instances**（MicrosoftLearning）[8](https://bing.com/search?q=AZ-104+study+guide+Microsoft+Learn+AZ-104T00+summary)