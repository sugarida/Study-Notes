# AZ-104 Final Cheatsheet（Exam Ready）

> Microsoft Learn の公式モジュールに基づき、AZ‑104 の試験頻出ポイントだけを超圧縮。  
> Identity（02）[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)[2](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/)[3](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)[4](https://www.youtube.com/watch?v=cke_6ytCDds)  
> Storage（04）[5](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)[6](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)[7](https://github.com/Azure/cloud-for-sovereignty-policy-portfolio)[8](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)  
> Networking（03）[9](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)[10](https://dev.to/i_am_vesh/az-104-implement-and-manage-storage-in-azure-16od)[11](https://reactor.microsoft.com/en-us/reactor/events/18742/)[12](https://www.youtube.com/watch?v=PtL7v-pFis0)[13](https://docs.azure.cn/en-us/dns/dns-delegate-domain-azure-dns)[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)  
> Compute（05）[15](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)[16](https://www.newhorizons.com/course-outline/courseid/200015042/coursename/az-104t00-microsoft-azure-administrator)[17](https://learn.microsoft.com/en-us/shows/beginners-series-to-microsoft-graph/module-2-understand-the-role-of-azure-active-directory-with-microsoft-graph)[18](https://www.linkedin.com/posts/nikhil-kamode_allow-users-to-reset-their-password-with-activity-7367178571972231168-EGqQ)[19](https://qiita.com/LimeSML/items/28e11c07138630234b10)

---

# 1. Identity / Governance（Entra ID / RBAC / Policy）

## ✔ Entra ID
- クラウド IDaaS。AD DS とは役割が異なる（GPO/LDAP なし）[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)  
- P1：条件付きアクセス / 動的グループ  
- P2：Identity Protection / PIM  

## ✔ Identity 管理
- ユーザー / グループ / ライセンス / 属性 / 自動プロビジョニング [2](https://learn.microsoft.com/en-us/training/modules/configure-storage-security/)  
- ハイブリッド同期（Entra Connect）：オンプレが **Single Source of Truth** [20](https://docs.azure.cn/en-us/role-based-access-control/)  

## ✔ RBAC（最重要）
- スコープ：**MG → Subscription → RG → Resource（継承あり）** [4](https://www.youtube.com/watch?v=cke_6ytCDds)  
- ロール：Owner / Contributor / Reader ほか  
- **ディレクトリロール ≠ Azure RBAC**（混同禁止）[20](https://docs.azure.cn/en-us/role-based-access-control/)  

## ✔ Azure Policy
- **Policy＝単体 / Initiative＝複数束ねる** [3](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)  
- Audit → Deny の段階適用  
- Sovereign 要件はレベル分割して設計 [21](https://www.linkedin.com/posts/attila-kozma-463758a6_configure-azure-files-and-azure-file-sync-activity-7300146404528635904-g7GT)  

---

# 2. Storage（Accounts / Blob / Files / Security）

## ✔ Storage Account
- **GPv2 が既定**（Premium は性能要件時）[5](https://techcommunity.microsoft.com/discussions/microsoft-entra/register-for-the-learn-live-episode/3793810)  
- 冗長化：LRS / ZRS / GRS / RA‑GRS / GZRS / RA‑GZRS  
- Firewall / Private Endpoint / Public Access 制御可能  

## ✔ Blob
- 階層：**Hot / Cool / Archive**（料金 × 頻度）[6](https://docs.azure.cn/en-us/virtual-network/tutorial-connect-virtual-networks)  
- Lifecycle：自動移行 / 削除  
- Object Replication：非同期レプリケーション  

## ✔ Security（SAS）
- SAS パラメータ：期限 / 権限 / IP / HTTPS 限定 [7](https://github.com/Azure/cloud-for-sovereignty-policy-portfolio)  
- 暗号化：SSE（既定） → CMK（Key Vault 使用）[7](https://github.com/Azure/cloud-for-sovereignty-policy-portfolio)  
- **キーアクセス無効化 / TLS1.2** 推奨 [22](https://www.microsoft.com/en-us/industry/blog/government/sovereignty/2024/04/24/streamline-controls-with-microsoft-cloud-for-sovereignty/)  

## ✔ Azure Files
- SMB/NFS：共有単位で選択（両用不可）[8](https://learn.microsoft.com/en-us/training/modules/control-network-traffic-flow-with-routes/)  
- ID 認証 + Private Endpoint  
- File Sync：オンプレキャッシュ／多拠点配布  

---

# 3. Virtual Network（VNet / NSG / DNS / Peering / UDR / LB / AppGW）

## ✔ VNet
- **アドレス重複＝Peering 不可（必ず押さえる）** [9](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)  
- Subnet で役割分離（front/back/DMZ）  

## ✔ NSG
- 適用：Subnet / NIC  
- **評価順＝優先度 → 既定ルール** → Effective Rules で確認 [10](https://dev.to/i_am_vesh/az-104-implement-and-manage-storage-in-azure-16od)  
- ASG：役割単位で論理グループ化（大規模環境向け）  

## ✔ DNS
- Public：ゾーン → レコード → **レジストラへ NS 委任** [11](https://reactor.microsoft.com/en-us/reactor/events/18742/)  
- Private：**VNet Link + auto-registration**（VM自動登録）[23](https://learn.microsoft.com/en-us/azure/virtual-machines/availability)  

## ✔ Peering
- MS バックボーンで低遅延  
- Transit：Hub（Allow gateway transit）⇄ Spoke（Use remote）[12](https://www.youtube.com/watch?v=PtL7v-pFis0)  

## ✔ UDR
- Next hop：Virtual appliance（NVA）/ Internet / VNet / Peering  
- **対称ルーティング必須**（崩れると通信不可）[13](https://docs.azure.cn/en-us/dns/dns-delegate-domain-azure-dns)  

## ✔ Load Balancer（L4）
- TCP/UDP、Standard SKU  
- Health Probe / LB Rule / **HA Ports**（全ポート LB）[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)  

## ✔ Application Gateway（L7）
- WAF / Path・Host ルーティング  
- URL/ヘッダ要件 → AppGW、L4 → LB [14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)  

## ✔ Network Watcher
- IP Flow Verify（NSG 判定）  
- Next Hop（UDR 判定）  
- Packet Capture（VM パケット）  
- NSG Flow Logs（トラフィック）  
- Connection Monitor（疎通監視）[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)  

---

# 4. Compute（VM / Availability / App Service / ACI）

## ✔ Virtual Machines
- 作成前：RG / Region / Size / Image / Disk / Network / 可用性 / Backup を決める [15](https://docs.azure.cn/en-us/azure-resource-manager/templates/overview)  

## ✔ Availability
- AZ：**物理分散（最強）** [24](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)  
- AS：UD/FD の論理分散（2 台以上）[16](https://www.newhorizons.com/course-outline/courseid/200015042/coursename/az-104t00-microsoft-azure-administrator)  
- VMSS：Autoscale（負荷・スケジュール）  

## ✔ App Service Plan
- プラン＝OS / Region / 機能 / 上限 / スケール の決定要素  
- **Scale up（ティア） / Scale out（インスタンス）** [17](https://learn.microsoft.com/en-us/shows/beginners-series-to-microsoft-graph/module-2-understand-the-role-of-azure-active-directory-with-microsoft-graph)  

## ✔ App Service
- スロット（Staging ⇄ Production）を **Swap**  
- カスタムドメイン／TLS／バックアップ／App Insights [18](https://www.linkedin.com/posts/nikhil-kamode_allow-users-to-reset-their-password-with-activity-7367178571972231168-EGqQ)  

## ✔ ACI（Azure Container Instances）
- 最速デプロイ（VM なし）  
- Container Group（同ホスト & ライフサイクル）  
- Public FQDN / VNet 統合 / Azure Files [19](https://qiita.com/LimeSML/items/28e11c07138630234b10)  

---

# 5. Monitoring / Backup

## ✔ Monitoring（Azure Monitor）
- Metrics（リアルタイム数値）  
- Logs（LAW, KQL）  
- Diagnostic Settings（LAW / Storage / EventHub に送信）  

## ✔ Network Watcher（診断）
- Connection Monitor / IP Flow Verify / Next Hop / Packet Capture / NSG Flow Logs  
[14](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)  

## ✔ Backup
- **Recovery Services Vault（RSV）**  
- バックアップポリシー（スケジュール & 保持）  
- 復旧は RSV → Backup Items  

---

# 6. 試験で混同しやすい比較

| 項目 | 比較 | 覚え方 |
|------|------|--------|
| RBAC | ディレクトリロール ≠ Azure RBAC | Identity と Azure リソース管理は別物 |
| ネットワーク | UDR vs NSG | UDR＝経路、NSG＝FW |
| L4/L7 | LB vs AppGW | URL/WAF 要る？ → AppGW |
| Storage 権限 | Key / SAS / Managed Identity | 安全性は **MI > SAS > Key** |
| Compute | AZ / AS / VMSS | 物理 / 論理 / 水平スケール |

---

# 7. 最後の 30 秒チェック

- アドレス重複 → Peering ❌  
- SAS は最小権限・短期間・IP 制限  
- Storage は GPv2 が基本  
- AS＝UD+FD（2台以上）、AZ＝物理分散  
- App Service Swap  
- ACI＝最速  
- Network Watcher の 5 機能  
- RBAC と Entra ロール区別  