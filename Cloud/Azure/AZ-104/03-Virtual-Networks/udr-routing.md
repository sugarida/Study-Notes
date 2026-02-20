# Control network traffic with routes（UDR / NVA ルーティング）

> 本ノートは **“Manage and control traffic flow with routes”** モジュールとルーティングチュートリアルの要点を整理。**UDR と NVA（FW）経由**の設計が頻出。[12](https://docs.azure.cn/en-us/dns/dns-delegate-domain-azure-dns)[13](https://learn.microsoft.com/en-us/training/modules/secure-azure-resources-with-rbac/)

## 1. 既定ルーティングと UDR
- VNet 内のサブネット間は**既定で相互到達**。要件に応じて **UDR（Route table）** を作り、**Next hop** に `Virtual appliance`（NVA/FW など）を指定して**経路上書き**する。[12](https://docs.azure.cn/en-us/dns/dns-delegate-domain-azure-dns)

## 2. NVA 経由の代表手順（Portal）
1) `DMZ` に **NVA**、`Private` に **VM** を配置  
2) `Route table` を作成し、`0.0.0.0/0 → Virtual appliance（NVA IP）` を追加  
3) 対象サブネットに `Route table` を関連付け  
4) 送受信が **対称経路** になるよう NSG/戻り経路も確認。[13](https://learn.microsoft.com/en-us/training/modules/secure-azure-resources-with-rbac/)

## 3. 試験チェック
- **Next hop 種別**（Virtual appliance / Internet / Vnet peering など）を 3 つ挙げて説明できるか。[13](https://learn.microsoft.com/en-us/training/modules/secure-azure-resources-with-rbac/)
- **対称ルーティング**が崩れると通信破綻（セッション破棄）を短文で言えるか。[12](https://docs.azure.cn/en-us/dns/dns-delegate-domain-azure-dns)

### 参考
- モジュール：**Manage and control traffic flow with routes**（Official Learn）[12](https://docs.azure.cn/en-us/dns/dns-delegate-domain-azure-dns)  
- Docs：**Tutorial: Route network traffic with a route table**（Portal 手順）[13](https://learn.microsoft.com/en-us/training/modules/secure-azure-resources-with-rbac/)