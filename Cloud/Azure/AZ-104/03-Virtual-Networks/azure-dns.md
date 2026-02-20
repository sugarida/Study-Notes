# Host your domain on Azure DNS（Public/Private DNS の要点）

> 本ノートは **“Host your domain on Azure DNS”** モジュールと Docs の要点を整理。**委任手順（NS）** と **Private DNS の VNet リンク** が鍵。[5](https://www.youtube.com/watch?v=B1TH1552dIY)[6](https://reactor.microsoft.com/en-us/reactor/events/18742/)

## 1. Public DNS（委任の 4 ステップ）
1) **DNS ゾーン作成**（例：contoso.com）  
2) **レコード作成**（A/CNAME 等）  
3) **Azure Nameserver (NS)** を取得  
4) **レジストラ側で NS を設定（委任）** → インターネットから解決可能に。[6](https://reactor.microsoft.com/en-us/reactor/events/18742/)

## 2. Private DNS（内部名解決）
- **Private DNS Zone** を作成し、**VNet リンク**で VNet と関連付け。**自動登録 (auto-registration)** を ON にすると、VM の A レコードが自動生成される。[7](https://learn.microsoft.com/en-us/azure/virtual-machines/availability)

## 3. ラボ（手早く復習）
- **Host your domain on Azure DNS – 公式サンプル**（LB/VM を伴うセットアップスクリプトあり）。[8](https://learn.microsoft.com/en-us/training/modules/configure-virtual-machine-availability/)

## 4. 試験チェック
- **Public と Private** の違いと、**NS 委任**・**VNet リンク**のキーワードを 30 秒で説明できるか。[5](https://www.youtube.com/watch?v=B1TH1552dIY)[6](https://reactor.microsoft.com/en-us/reactor/events/18742/)

### 参考
- モジュール：**Host your domain on Azure DNS**（Official Learn）[5](https://www.youtube.com/watch?v=B1TH1552dIY)  
- Docs：**Tutorial: Host your domain in Azure DNS**（委任手順）[6](https://reactor.microsoft.com/en-us/reactor/events/18742/)  
- サンプル：**mslearn-host-domain-azure-dns（GitHub）** [8](https://learn.microsoft.com/en-us/training/modules/configure-virtual-machine-availability/)