# Configure virtual machine availability（AZ / AS / UD・FD / VMSS・Autoscale）

> 本ノートは **“Configure virtual machine availability”** モジュールと可用性設計ドキュメントを要約。**物理分散（AZ） / 論理分散（AS） / 水平スケール（VMSS）** がコア。[3](https://www.newhorizons.com/course-outline/courseid/200015042/coursename/az-104t00-microsoft-azure-administrator)[4](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)

## 1. 可用性ゾーン（Availability Zones：AZ）
- 同一リージョン内の**物理的に独立したゾーン**へ分散し、**データセンター障害**に耐える。3 ゾーン構成のリージョンが対象。[4](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)  
- VMSS も**ゾーン展開 / 単ゾーン / リージョナル**を選択可能（オーケストレーション モードによって挙動が異なる点に注意）。[4](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)

## 2. 可用性セット（Availability Sets：AS）
- **更新ドメイン（UD）**と**障害ドメイン（FD）**で**論理分散**し、計画メンテや単一障害点の影響を局所化する。**2 台以上**を AS に配置して冗長化。[3](https://www.newhorizons.com/course-outline/courseid/200015042/coursename/az-104t00-microsoft-azure-administrator)[4](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)

## 3. VM スケールセット（VMSS）とオートスケール
- **需要 / スケジュール**に応じて**自動でスケールアウト/イン**（スケールセット自体に費用は発生せず、**実 VM のみ課金**）。[4](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)  
- VMSS は LB と組み合わせ、**高可用性 + スケーラビリティ**を両立できる。[4](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)

## 4. 設計の使い分け
- **物理障害対策の最優先**＝**AZ**、**コスト最小で論理分散**＝**AS**、**需要変動に対応**＝**VMSS + Autoscale**。[3](https://www.newhorizons.com/course-outline/courseid/200015042/coursename/az-104t00-microsoft-azure-administrator)[4](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)

## 5. 試験チェック
- 「**AZ と AS の違い**」「**UD/FD の意味**」「**VMSS の Autoscale 条件**」を 1 行ずつ言えるか。[3](https://www.newhorizons.com/course-outline/courseid/200015042/coursename/az-104t00-microsoft-azure-administrator)[4](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)

### 参考
- モジュール：**Configure virtual machine availability**（Official Learn）[3](https://www.newhorizons.com/course-outline/courseid/200015042/coursename/az-104t00-microsoft-azure-administrator)  
- Docs：**Availability options for Azure Virtual Machines**（AZ / AS / VMSS / LB の総覧）[4](https://www.globalknowledge.com/us-en/course/184475/microsoft-azure-administrator-az-104t00/)