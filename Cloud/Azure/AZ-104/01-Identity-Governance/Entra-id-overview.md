# Understand Microsoft Entra ID（旧 Azure AD）概要

> 本ノートは AZ‑104 の「Understand Microsoft Entra ID」モジュールをベースに、試験と実務の要点だけを圧縮したものです。[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)

## 1. Entra ID とは（役割と位置づけ）
- **クラウドベースの IDaaS（Identity as a Service）**。組織のユーザー／アプリ／デバイスに対する**認証・認可**を提供するディレクトリサービス。[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)
- **オンプレ AD DS との違い**：AD DS はドメイン／フォレスト／GPO／LDAP を中心とするオンプレのディレクトリ。Entra ID は**クラウドアプリ認証や条件付きアクセスを中心**に据える。[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)

## 2. ライセンスの違い（試験で問われやすい）
- **P1**：条件付きアクセス、動的グループなどの運用機能を提供。[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)
- **P2**：**Identity Protection / Privileged Identity Management (PIM)** など特権・リスク管理を強化。[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)

## 3. Entra Domain Services（EDS）
- **マネージドドメイン**（Kerberos / NTLM / LDAP サポート）。DC を自前で構築せず、従来型アプリをクラウド側で動かすときに有効。[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)

## 4. 学習の観点（試験 & 実務）
- **テナント／ディレクトリ／サブスクリプション**の用語と関係を正確に。Entra のロールと **Azure RBAC は別物**（Identity と Resource の権限系が異なる）。[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)
- **条件付きアクセス・多要素認証**は P1 以上の代表機能として位置付けられる。[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)

## 5. チェックポイント
- Entra ID と AD DS の**責務の線引き**を説明できるか？（クラウド認証／SaaS 連携 vs LDAP/GPO/ドメイン参加）[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)
- P1 と P2 の**代表機能**を 1 行で言えるか？（P1＝条件付きアクセス、P2＝Identity Protection/PIM）[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)
- EDS は**レガシープロトコル互換のためのマネージドドメイン**であることを押さえる。[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)

## 参考
- モジュール：**Understand Microsoft Entra ID**（Official Learn）[1](https://learn.microsoft.com/ja-jp/training/modules/secure-azure-resources-with-rbac/)