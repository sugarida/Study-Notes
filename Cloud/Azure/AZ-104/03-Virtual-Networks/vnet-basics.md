# Configure virtual networks（VNet 基礎・設計・アドレス計画）

> 本ノートは **“Configure virtual networks”** モジュールの要点（VNet/サブネット/IP 設計）を、試験と実務の観点で最短整理。[1](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)

## 1. 目的と役割
- **Azure Virtual Network (VNet)** は、Azure リソース間・インターネット・オンプレを**安全に接続する境界**。全リソースは**必ずサブネット**に所属して動作する。[1](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)

## 2. アドレス設計（最重要）
- プライベート IP（RFC1918）で**十分な余剰**を取り、**将来の Peering/ExpressRoute/VPN** を見据えて**重複を回避**する。[1](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)
- **Public/Private IP** の使い分け：内部通信は Private、公開面は LB/AppGW などに Public IP を付与（SKU/動的静的も設計時に決定）。[1](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)

## 3. サブネット分割の基本
- 最小限：**フロントエンド / バックエンド / 管理（または DMZ）** に分離し、後続の NSG/UDR と合わせてゼロトラストを実現。[1](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)

## 4. 代表手順（Portal）
1) **VNet 作成**（例：10.1.0.0/16）  
2) **Subnet 作成**（frontend 10.1.0.0/24、backend 10.1.1.0/24）  
3) 必要に応じて **Public IP** を作成して LB/AppGW 等へ割当（SKU を Standard 前提で選定）。[1](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)

## 5. Hub-Spoke（よく出る設計）
- `hub-vnet`（FW/共通基盤）+ `app-vnet`（業務）を同一リージョンに用意し、後続の **VNet peering** で閉域接続する（学習ラボの典型パターン）。[2](https://learn.microsoft.com/en-us/training/paths/az-104-manage-storage/)

## 6. 試験チェック
- **アドレス重複は Peering 不可**を一言で説明できるか。[1](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)
- 「VNet＝境界、サブネット＝配置単位、Public/Private IP の使い分け」を 30 秒で言えるか。[1](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)

### 参考
- モジュール：**Configure virtual networks**（Official Learn）[1](https://www.oreilly.com/videos/exam-az-104-microsoft/9780136823483/9780136823483-A104_02_05_02/)  
- ラボ：**Create and configure virtual networks（Hub-Spoke/Peering）**（MicrosoftLearning）[2](https://learn.microsoft.com/en-us/training/paths/az-104-manage-storage/)