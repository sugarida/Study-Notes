# Configure Azure Files（SMB/NFS と Azure File Sync）

> 本ノートは AZ‑104 の **“Configure Azure Files”** モジュールをベースに、**ファイル共有の使い分けと File Sync** を最短で把握できるように整理。[7](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)

## 1. Azure Files と Blob の使い分け
- **Azure Files**：SMB/NFS で **共有フォルダ**を提供。アプリのリフト&シフト・ユーザープロファイル・ツール共有などに最適。[7](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)
- **Blob**：大規模 **オブジェクト**格納（REST/SDK）。ファイルシステム機能が不要な非構造化データ向け。[7](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)

## 2. 共有／プロトコル／階層
- **同一共有内で SMB/NFS の併用は不可**（アカウント内で別共有なら可）。**Premium（FileStorage）** は IOPS/低遅延が必要な用途で採用。**スナップショット**で PIT 復元。[7](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)

## 3. アクセス制御とネットワーク
- **ID ベース SMB 認証**（Entra/AD DS）を推奨。**Private Endpoint** で閉域化し、ポート 445 の到達性も考慮（到達できない場合は VPN/ExpressRoute + Private Endpoint）。[7](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)

## 4. Azure File Sync（ハイブリッドキャッシュ）
- **Storage Sync Service** → **Windows Server へのエージェント** → **Sync Group（Cloud/Server endpoint）** で、**多拠点キャッシュとクラウド階層化**を構成。[7](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)

## 5. ラボ（役立つシナリオ）
- **Premium FileShares（ZRS）** で共有を作成 → ディレクトリ構成 → スナップショット/復元 → **VNet 制限** を確認（公式のガイド付きラボで手早く習得）。[8](https://meapsa.com/home/Modules/control-network-traffic-flow-with-routes)

## 6. チェックポイント（試験）
- 「共有単位で SMB/NFS を選ぶ」／「Premium は高 IOPS/低遅延用途」／「ID ベース認証と Private Endpoint を優先」の 3 点を 30 秒で説明できるか。[7](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)

### 参考
- モジュール：**Configure Azure Files and Azure File Sync**（Official Learn）[7](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)  
- ラボ：**Secure storage… – File shares（Premium/ZRS など）**（MicrosoftLearning）[8](https://meapsa.com/home/Modules/control-network-traffic-flow-with-routes)