# Monitoring Basics（Diagnostic settings / Metrics / Logs）

> 本ノートは AZ‑104 の Compute / Network / Storage モジュールに散在する  
> 「監視」「ログ」「診断設定」要素を整理したものです。  
> 特に **Network Watcher（VNet 学習パス）**内で明確に扱われる監視要素を中心に構成しています。[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

---

## 1. Azure Monitor の基本構造

Azure Monitor は「**Metrics（メトリック）**」と「**Logs（ログ）**」の2軸でリソースを監視する。

### ● Metrics（メトリック）
- リアルタイム寄り、数値データ（CPU／メモリ／ディスク IOPS／ネットワーク etc）
- 分解能が高く、**アラート条件に利用されることが多い**

### ● Logs（ログ）
- Log Analytics Workspace (LAW) に集約される  
- KQL（Kusto Query Language）で検索・分析  
- Activity Logs（管理操作） and Resource Logs（NSG/VM/Storage等のログ）

### ● Diagnostic Settings（診断設定）
- リソースログ（Resource logs）を  
  - **Log Analytics Workspace**  
  - **Storage Account**  
  - **Event Hub**  
 へ送信する構成  
- Network Watcher / NSG Flow Logs / Storage 監査ログなどがこの仕組みを利用

---

## 2. Network Watcher に絡む監視（試験頻出）

Network Watcher モジュールには以下が含まれ、**いずれも Azure Monitor と密接に連携**する：  
- **Connection Monitor**（到達性）  
- **NSG Flow Logs**（トラフィックログ）  
- **Packet Capture**（対象 VM のパケット採取）  
- **IP Flow Verify**（NSG 判定）  
- **Next Hop**（UDR 判定）  
[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

これらは Exam AZ‑104 のネットワーク診断問題で頻出。

---

## 3. アラート（Alert Rules）

アラートは以下の3種：

| 種類 | 例 | 補足 |
|------|------|------|
| **Metrics アラート** | CPU > 80% | 最も一般的 |
| **Log アラート** | KQL 条件に一致 | LAW 必須 |
| **Activity Log アラート** | VM 削除イベント | 管理操作の検出 |

---

## 4. 試験チェック（よく問われるポイント）
- **Metrics と Logs の違いを説明できるか？**  
- **Diagnostic Settings でどこに送れるか？（LAW / Storage / Event Hub）**  
- **Network Watcher の機能（Connection monitor / NSG flow logs / Packet capture）を説明できるか？** [1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)

---

## 参考
- AZ‑104 Network 学習パス：**Network Watcher と診断系** [1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)