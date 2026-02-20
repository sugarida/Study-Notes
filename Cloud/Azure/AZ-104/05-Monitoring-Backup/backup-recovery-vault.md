# Backup & Recovery Services Vault（Azure Backup 基本）

> AZ‑104 では「深くは問われないが確実に範囲内」。  
> VM バックアップをするには **Recovery Services Vault（RSV）** を構成する。

---

## 1. Recovery Services Vault（RSV）とは
- バックアップ・復旧の管理コンテナ  
- Azure Backup（VM / SQL / Files）や Site Recovery を格納  
- データ保持・ポリシー・復旧ポイント管理を行う

---

## 2. Azure Backup の流れ（VM バックアップ）
1. **RSV を作成**（リージョン/リソースグループ選択）  
2. **Backup を構成**  
3. **Backup Policy（スケジュール & 保持期間）** を設定  
4. 復旧時は RS Vault → Backup Items → Recover から操作

---

## 3. 代表的な Backup ポリシー項目
- Backup 時刻  
- 毎日/毎週/毎月 の保持ルール  
- 長期保持（LTR）  
- 暗号化（既定は SSE）

---

## 4. 試験で問われるポイント
- Azure Backup では **スナップショットベース**の仕組みを使い、  
  物理的なフルコピーではない  
- 復旧ポイントは **RSV 内で管理**  
- 「VM をバックアップしたい → RSV が必要」  
- 「ログ / NSG Flow / Diagnostics は Backup ではなく Monitor 領域」

---

## 5. Network Watcher との比較（覚え方）
| 種類 | 目的 |
|------|-----------------------------|
| Network Watcher | **通信診断・到達性確認**（運用系） |
| Azure Backup | **データ保護・復旧**（保護系） |

---

## 参考
- Monitor 部分：Network Watcher（AZ‑104 Network 学習パス）[1](https://learn.microsoft.com/en-us/training/modules/configure-blob-storage/)  