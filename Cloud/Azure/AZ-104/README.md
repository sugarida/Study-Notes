# AZ-104 Study Notes 📘
**Microsoft Azure Administrator – AZ‑104 対策用リポジトリ**

このリポジトリは、Microsoft Learn の公式モジュールに準拠しながら  
**試験合格に必要な知識を体系的にまとめた学習ノート集**です。

全体構成は AZ‑104 の 4 領域（Identity / Storage / Network / Compute）に基づき、  
フォルダ単位でメモを整理しています。  
最後に **Monitoring / Backup** と **CheatSheet** も収録。

---

# 📁 フォルダ構成
Cloud/
└── Azure/
    └── AZ-104/
        ├── 01-Identity-Governance/
        │   ├── entra-id-overview.md
        │   ├── identities-management.md
        │   ├── azure-policy-governance.md
        │   ├── rbac.md
        │   └── sspr.md
        │
        ├── 02-Storage/
        │   ├── storage-accounts.md
        │   ├── blob-storage.md
        │   ├── storage-security.md
        │   └── azure-files.md
        │
        ├── 03-Virtual-Networks/
        │   ├── vnet-basics.md
        │   ├── nsg-asg.md
        │   ├── azure-dns.md
        │   ├── vnet-peering.md
        │   ├── udr-routing.md
        │   ├── load-balancer.md
        │   ├── application-gateway.md
        │   └── network-watcher.md
        │
        ├── 04-compute/
        │   ├── virtual-machines.md
        │   ├── vm-availability.md
        │   ├── app-service-plans.md
        │   ├── app-service.md
        │   └── container-instances.md
        │
        ├── 05-Monitoring-Backup/
        │   ├── monitoring-basics.md
        │   ├── network-watcher-tools.md
        │   └── backup-recovery-vault.md
        │
        ├── az104-cheatsheet.md
        └── README.md

# 🎯 学習方針

このリポジトリでは以下の 3 レイヤーで学習できます：

### **1. 詳細ノート（フォルダ内 .md）**
各モジュールの内容を  
**試験 / 実務 両方に耐える深さで整理**しています。

### **2. 分野別まとめ（章ごとの理解用）**
Identity / Storage / Network / Compute  
それぞれの知識を体系的に理解する用。

### **3. 試験用チートシート（超短期用）**
`cheatsheets/` に置かれている：

- **az104-cheatsheet.md** → GitHub で読む用  
- **az104-cheatsheet.pdf** → 印刷/試験前の最終チェック用  

---

# 🧩 主要トピック一覧

## 01. Identity & Governance
- Entra ID 概要（クラウド IDaaS）
- ユーザー・グループ・ライセンス管理
- RBAC（範囲・継承・ロール）
- Azure Policy & Initiatives（Audit/Deny）
- SSPR（Writeback）

## 02. Storage
- Storage Account（SKU / 冗長化）
- Blob（階層・Lifecycle・Replication）
- Storage Security（SAS / CMK / Secure Transfer）
- Azure Files（SMB/NFS / File Sync）

## 03. Virtual Networks
- VNet（アドレス計画）
- NSG/ASG（ルール評価順）
- DNS（Public NS・Private DNS）
- VNet Peering（Transit）
- UDR（Virtual Appliance / 対称ルーティング）
- L4 LB / Application Gateway L7
- Network Watcher（診断）

## 04. Compute
- VM 作成前チェック（サイズ/イメージ/ディスク）
- 可用性（AZ / AS / VMSS）
- App Service Plan（Scale up/out）
- App Service（デプロイスロット）
- ACI（最速デプロイ＆VNet）

## 05. Monitoring / Backup
- Azure Monitor（Metrics / Logs / Diagnostic Settings）
- Network Watcher ツール（IP Flow Verify など）
- Recovery Services Vault（Backup）

---

# 📦 Cheatsheet（試験前日〜当日用）

### 📝 Markdown（GitHub）
- cheatsheets/az104-cheatsheet.md

### 📄 PDF（印刷用）
- cheatsheets/az104-cheatsheet.pdf

---

# 🛠️ 使用教材・参照元（Microsoft Learn）

本リポジトリは以下の学習パスに沿って作成しています：

- **AZ-104: Implement and manage storage in Azure**  
- **AZ-104: Configure and manage virtual networks for Azure administrators**  
- **AZ-104: Deploy and manage Azure compute resources**  
- **Azure governance, RBAC, identity modules**  

（各ノート内で Learn 公式の引用を明記）

---

# 🤝 Contribution

- 誤字・改善点・追加ノートなどは **Issue / PR** で歓迎します  
- 個人学習用途のため、自由に Fork して使ってください  

---

# 🔥 あとがき

このリポジトリは、試験合格だけでなく  
**日々の Azure 運用・設計にも使える “永続型ノート”** を目指しています。

Azure の知識は繰り返し触れて定着するので、  
必要なときに常に参照できるよう GitHub で育てていきましょう。

Happy Learning ☁️✨  