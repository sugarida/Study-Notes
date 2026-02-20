# Introduction to Azure Virtual Machines（作成前チェック / 作成方法 / 運用連携）

> 本ノートは **“Introduction to Azure virtual machines”** モジュール準拠。作成前のチェックリスト、作成・管理方法、周辺サービス連携を最短整理。[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)

## 1. VM を作る前のチェックリスト
- **リソースグループ / リージョン / 可用性要件（AZ or AS）** を先に決める。[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)  
- **サイズ・イメージ・ディスク**（OS / データ / キャッシュ方針）を用途に合わせて選定する。[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)  
- **ネットワーク**（VNet/サブネット/NSG/パブリックIP の要否）を明確化する。[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)  
- **運用連携**（Azure Monitor / Backup / 拡張機能）を最初から有効化設計に含める。[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)[2](https://cloudpulse.blog/a-step-by-step-guide-to-azure-resource-manager-arm-templates/)

## 2. 作成・管理の選択肢
- **Azure Portal / PowerShell / CLI / ARM・Bicep / REST** のいずれでも作成・変更・自動化が可能。[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)  
- 公式ドキュメントの **VM 総合ポータル**からサイズや最新機能、トラブルシュート、WAF ベストプラクティスまで横断的に参照できる。[2](https://cloudpulse.blog/a-step-by-step-guide-to-azure-resource-manager-arm-templates/)

## 3. 周辺サービス（代表）
- **Azure Monitor**：メトリック・ログ収集で可視化・アラート化を行う。[2](https://cloudpulse.blog/a-step-by-step-guide-to-azure-resource-manager-arm-templates/)  
- **Azure Backup**：Recovery Services Vault 経由で VM バックアップ・復旧を行う。[2](https://cloudpulse.blog/a-step-by-step-guide-to-azure-resource-manager-arm-templates/)  
- **VM 拡張機能（Extensions）**：エージェント不要でスクリプト実行・監視・構成適用などを自動化。[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)

## 4. 試験チェック
- 「**作成前チェック項目**」を 30 秒で列挙できるか（RG/Region/サイズ/イメージ/ディスク/ネットワーク/可用性/運用）。[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)  
- 「**作成手段の種類**」と「**拡張機能での運用自動化**」を説明できるか。[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)

### 参考
- モジュール：**Introduction to Azure virtual machines**（Official Learn）[1](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)  
- Docs ハブ：**Virtual machines in Azure**（最新サイズ/設計/チュートリアル/トラブルシュート集約）[2](https://cloudpulse.blog/a-step-by-step-guide-to-azure-resource-manager-arm-templates/)