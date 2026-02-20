# Configure VNet peering（ピアリング / ゲートウェイトランジット）

> 本ノートは **“Configure Azure Virtual Network peering”** モジュールの要点を最短で。**バックボーン通信 / アドレス重複不可 / Transit** が肝。[9](https://www.youtube.com/watch?v=PtL7v-pFis0)

## 1. 基本
- **同/異リージョン** の VNet を**Microsoft バックボーン**で低遅延接続。**アドレス空間が重複していると不可**。[9](https://www.youtube.com/watch?v=PtL7v-pFis0)

## 2. トランジット（Hub&Spoke）
- Hub VNet に VPN/ER ゲートウェイがある場合、Spoke から **Use remote gateway**、Hub 側で **Allow gateway transit** を有効にして**トランジット**を実現。[9](https://www.youtube.com/watch?v=PtL7v-pFis0)

## 3. 手順（Portal）
- `VNet-A` の **Peerings** で `VNet-B` へピアリング作成 → 反対側にも相互ピアが自動生成 → **Peering status = Connected** を確認。[10](https://www.youtube.com/watch?v=vds4vr1N80g)[11](https://qiita.com/LimeSML/items/0ad37304c893b354cf3a)

## 4. 注意点
- **NSG/UDR は VNet をまたいで自動適用されない**（それぞれの VNet/サブネット側で設計）。[9](https://www.youtube.com/watch?v=PtL7v-pFis0)

### 参考
- モジュール：**Configure VNet peering**（Official Learn）[9](https://www.youtube.com/watch?v=PtL7v-pFis0)  
- デモ：**Configure VNet Peering（AZ‑700/AZ‑104 リソース）** [10](https://www.youtube.com/watch?v=vds4vr1N80g)[11](https://qiita.com/LimeSML/items/0ad37304c893b354cf3a)