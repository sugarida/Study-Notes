# Azure Policy / Governance / Sovereignty（基礎と実装手順）

> 「Policy と Initiative の違い」「一括適用」「Sovereign 要件のコード化」が試験の核。[4](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)[5](https://www.linkedin.com/posts/attila-kozma-463758a6_configure-azure-files-and-azure-file-sync-activity-7300146404528635904-g7GT)

## 1. 用語の整理
- **Azure Policy**：**単一**のガバナンスルール（例：特定リージョン以外のデプロイを拒否）。[4](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)
- **Initiative**：複数 Policy を**コレクション化**したもの。**割当は Initiative を基本**にすると運用が容易。[4](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)

## 2. 何ができるか（試験観点）
- 組織標準や規制（タグ、リソース種別、リージョン、SKU、暗号化など）を**コード化して評価/強制**できる。[4](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)
- **Audit → Deny** の段階移行で影響把握しながら厳格化するのが実務の定石。[5](https://www.linkedin.com/posts/attila-kozma-463758a6_configure-azure-files-and-azure-file-sync-activity-7300146404528635904-g7GT)

## 3. Sovereignty（主権要件）の設計指針
- **データ所在地／転送時暗号／保存時暗号（CMK）／機密計算**などの統制を**レベル（L1〜L3 等）**に分解して設計。[5](https://www.linkedin.com/posts/attila-kozma-463758a6_configure-azure-files-and-azure-file-sync-activity-7300146404528635904-g7GT)
- **Microsoft Cloud for Sovereignty** の **Policy Portfolio（GitHub）** をベースに自社要件で拡張可能。[6](https://passitexams.com/articles/az-104-implement-and-manage-storage/)

## 4. 実装ステップ（最小パス）
1) 要件を Policy（規則）に分解 → 2) Initiative に束ねる → 3) **スコープ**（MG/Subscription/RG）へ割当 → 4) **Audit** で差分可視化 → 5) **Deny** 適用。[4](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)[5](https://www.linkedin.com/posts/attila-kozma-463758a6_configure-azure-files-and-azure-file-sync-activity-7300146404528635904-g7GT)

## 5. チェックポイント
- Policy と Initiative の**違い**を 1 行で説明できるか。[4](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)
- **Audit → Deny** の移行方針と、**スコープ**の考え方（継承）を語れるか。[4](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)
- Sovereign 要件の**レベル化**設計を説明できるか。[5](https://www.linkedin.com/posts/attila-kozma-463758a6_configure-azure-files-and-azure-file-sync-activity-7300146404528635904-g7GT)

## 参考
- モジュール：**Azure Policy initiatives**（Official Learn）[4](https://charbelnemnom.com/deploy-and-set-up-azure-file-sync/)  
- 設計ガイド：**Design sovereign policy initiatives in Azure**（Official Learn）[5](https://www.linkedin.com/posts/attila-kozma-463758a6_configure-azure-files-and-azure-file-sync-activity-7300146404528635904-g7GT)  
- 例集：**Cloud for Sovereignty Policy Portfolio（GitHub）** [6](https://passitexams.com/articles/az-104-implement-and-manage-storage/)