# Configure network security groups（NSG/ASG とルール評価）

> 本ノートは **“Configure network security groups”** モジュール準拠。**評価順・既定ルール・ASG** が試験頻出。[3](https://dev.to/i_am_vesh/az-104-implement-and-manage-storage-in-azure-16od)

## 1. NSG の要点
- **サブネット/NIC** に適用し、L3/L4 の **Inbound/Outbound** を許可/拒否。**優先度**と**既定ルール**の理解が最重要。[3](https://dev.to/i_am_vesh/az-104-implement-and-manage-storage-in-azure-16od)
- **有効ルール（Effective security rules）** で NIC とサブネットの合成結果を確認する。[3](https://dev.to/i_am_vesh/az-104-implement-and-manage-storage-in-azure-16od)

## 2. ASG（Application Security Group）
- 同役割の VM を**論理グループ化**し、**NSG ルールの宛先/送信元**に ASG を指定して**ルール肥大化を防止**。[3](https://dev.to/i_am_vesh/az-104-implement-and-manage-storage-in-azure-16od)

## 3. 実装パターン（学習ラボ準拠）
- フロントエンド（ASG: `app-frontend-asg`）は **80/443** を Internet から許可。  
- バックエンドはフロントエンド ASG から DB ポートのみ許可。**NSG はサブネット or NIC** に関連付ける。[4](placeholder-0)

## 4. 試験チェック
- **評価順**（優先度の小さいルールが優先、既定ルールは下位）を説明できるか。[3](https://dev.to/i_am_vesh/az-104-implement-and-manage-storage-in-azure-16od)
- **ASG** の利点を 1 行で言えるか（VM の追加/削除に強く、ルール編集が簡潔）。[3](https://dev.to/i_am_vesh/az-104-implement-and-manage-storage-in-azure-16od)

### 参考
- モジュール：**Configure network security groups**（Official Learn）[3](https://dev.to/i_am_vesh/az-104-implement-and-manage-storage-in-azure-16od)  
- ラボ：**Create and configure network security groups（ASG/NSG）**（MicrosoftLearning）[4](placeholder-0)