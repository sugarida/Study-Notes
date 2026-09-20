# Lab 08：ネットワーク自動化（15%）🤖
**対象週：Week 17-18**

> ENCOR の 15% を占める。**ネットワークエンジニアが一番後回しにして落とす分野。**
> 逆に、Python を 1 行も書いたことがなくても **「curl で 1 回叩く」から始めれば怖くない。**

---

## 1. まず用語の整理

| 項目 | NETCONF | RESTCONF | SNMP |
|------|---------|----------|------|
| トランスポート | **SSH（TCP 830）** | **HTTPS（TCP 443）** | UDP 161/162 |
| データ形式 | **XML のみ** | **JSON または XML** | — |
| データモデル | **YANG** | **YANG** | MIB |
| 操作 | get / get-config / edit-config / commit | **GET / POST / PUT / PATCH / DELETE** | get / set / trap |
| トランザクション | **あり（candidate + commit）** | なし | なし |
| 用途 | 本格的な設定管理 | 手軽な API アクセス | 監視 |

> 🔥 **ポート番号（830 / 443）とデータ形式（XML のみ / JSON可）は必ず出る。**

### データ形式の比較
```json
// JSON（キー: 値、{} と []）
{ "hostname": "R1", "interfaces": ["Gi0/0", "Gi0/1"] }
```
```xml
<!-- XML（開始タグと終了タグ） -->
<device><hostname>R1</hostname></device>
```
```yaml
# YAML（インデントで階層、- でリスト）
hostname: R1
interfaces:
  - Gi0/0
  - Gi0/1
```
| 形式 | 特徴 | 主な用途 |
|------|------|----------|
| **JSON** | 軽量、人も機械も読める | REST API |
| **XML** | 厳格、スキーマ検証可 | NETCONF / SOAP |
| **YAML** | 最も人間向け、インデント必須 | **Ansible の Playbook / インベントリ** |

---

## 2. ルータ側の有効化

```cisco
! --- 共通の前提 ---
ip domain-name lab.local
crypto key generate rsa modulus 2048
username admin privilege 15 secret Ccnp12345
!
aaa new-model
aaa authentication login default local
aaa authorization exec default local
!
! --- NETCONF を有効化 ---
netconf-yang
!
! --- RESTCONF を有効化 ---
restconf
ip http secure-server
! （検証用途のみ。本番では http は無効にする）
no ip http server
```

### 確認
```cisco
show netconf-yang sessions
show netconf-yang statistics
show platform software yang-management process
show ip http server status | include HTTP server status|HTTPS
```
`show platform software yang-management process` の期待値:
```
confd            : Running
nesd             : Running
syncfd           : Running
ncsshd           : Running
dmiauthd         : Running
nginx            : Running
ndbmand          : Running
pubd             : Running
```
> 📌 **`nginx` が Running でないと RESTCONF は応答しない。**
> `ncsshd` が止まっていると NETCONF に繋がらない。ここが切り分けポイント。

---

## 3. RESTCONF を curl で叩く（ここから始める）

### URI の構造
```
https://<device>/restconf/data/<YANGモジュール>:<コンテナ>/<リーフ>
        └─ ルート ─┘ └ データストア ┘
```

### GET：ホスト名を取得
```bash
curl -k -u admin:Ccnp12345 \
  -X GET \
  -H "Accept: application/yang-data+json" \
  https://192.168.99.1/restconf/data/Cisco-IOS-XE-native:native/hostname
```
```json
{ "Cisco-IOS-XE-native:hostname": "R1" }
```

### PUT：ホスト名を変更
```bash
curl -k -u admin:Ccnp12345 \
  -X PUT \
  -H "Content-Type: application/yang-data+json" \
  -H "Accept: application/yang-data+json" \
  -d '{"Cisco-IOS-XE-native:hostname": "R1-VIA-RESTCONF"}' \
  https://192.168.99.1/restconf/data/Cisco-IOS-XE-native:native/hostname
```
→ ルータ側で `show running-config | include hostname` して**本当に変わったか確認する**。

### インターフェース一覧（標準 YANG モデル）
```bash
curl -k -u admin:Ccnp12345 \
  -H "Accept: application/yang-data+json" \
  https://192.168.99.1/restconf/data/ietf-interfaces:interfaces
```

### HTTP メソッドと意味（暗記）
| メソッド | 意味 | 冪等性 |
|---------|------|--------|
| **GET** | 取得 | ✅ |
| **POST** | 作成（子リソースを追加） | ❌ |
| **PUT** | **置換**（無ければ作成） | ✅ |
| **PATCH** | **部分更新**（マージ） | ✅ |
| **DELETE** | 削除 | ✅ |

### HTTP ステータスコード（出る）
| コード | 意味 |
|--------|------|
| **200 OK** | 成功（GET/PUT/PATCH） |
| **201 Created** | 作成成功（POST） |
| **204 No Content** | 成功、本文なし（PUT/DELETE） |
| **400 Bad Request** | リクエストの形式エラー |
| **401 Unauthorized** | **認証失敗** |
| **403 Forbidden** | **認可されていない** |
| **404 Not Found** | パスが存在しない |
| **409 Conflict** | 競合（既に存在する等） |
| **500 Internal Server Error** | サーバ側エラー |

---

## 4. Python で RESTCONF（requests）

```python
#!/usr/bin/env python3
"""RESTCONF でホスト名を取得・変更する最小サンプル"""
import json
import requests
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)  # ラボ用（自己署名証明書）

HOST = "192.168.99.1"
AUTH = ("admin", "Ccnp12345")
HEADERS = {
    "Accept": "application/yang-data+json",
    "Content-Type": "application/yang-data+json",
}
URL = f"https://{HOST}/restconf/data/Cisco-IOS-XE-native:native/hostname"


def get_hostname():
    r = requests.get(URL, auth=AUTH, headers=HEADERS, verify=False, timeout=10)
    print(f"status={r.status_code}")
    print(json.dumps(r.json(), indent=2))


def set_hostname(new_name):
    payload = {"Cisco-IOS-XE-native:hostname": new_name}
    r = requests.put(URL, auth=AUTH, headers=HEADERS,
                     data=json.dumps(payload), verify=False, timeout=10)
    print(f"status={r.status_code}")   # 204 なら成功


if __name__ == "__main__":
    get_hostname()
    set_hostname("R1-PY")
    get_hostname()
```

---

## 5. Python で NETCONF（ncclient）

```python
#!/usr/bin/env python3
"""NETCONF で設定を取得・投入する最小サンプル"""
from ncclient import manager
import xml.dom.minidom

DEV = {
    "host": "192.168.99.1",
    "port": 830,
    "username": "admin",
    "password": "Ccnp12345",
    "hostkey_verify": False,
    "device_params": {"name": "iosxe"},
}

# --- 1) 機器がサポートする YANG モデル（capability）を確認 ---
with manager.connect(**DEV) as m:
    for cap in m.server_capabilities:
        if "ietf-interfaces" in cap:
            print(cap)

# --- 2) get-config で現在の設定を取得 ---
FILTER = """
<filter>
  <native xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native">
    <hostname/>
  </native>
</filter>
"""
with manager.connect(**DEV) as m:
    reply = m.get_config(source="running", filter=FILTER)
    print(xml.dom.minidom.parseString(reply.xml).toprettyxml(indent="  "))

# --- 3) edit-config で設定投入 ---
CONFIG = """
<config>
  <native xmlns="http://cisco.com/ns/yang/Cisco-IOS-XE-native">
    <interface>
      <Loopback>
        <name>100</name>
        <description>Created by NETCONF</description>
        <ip>
          <address>
            <primary>
              <address>10.100.100.1</address>
              <mask>255.255.255.255</mask>
            </primary>
          </address>
        </ip>
      </Loopback>
    </interface>
  </native>
</config>
"""
with manager.connect(**DEV) as m:
    m.edit_config(target="running", config=CONFIG)
```
→ ルータ側で確認:
```cisco
show running-config interface Loopback100
show netconf-yang sessions
```

---

## 6. Netmiko（CLI を自動化する。一番実務で使う）

```python
#!/usr/bin/env python3
from netmiko import ConnectHandler

device = {
    "device_type": "cisco_ios",
    "host": "192.168.99.1",
    "username": "admin",
    "password": "Ccnp12345",
    "secret": "Ccnp12345",
}

with ConnectHandler(**device) as conn:
    conn.enable()
    print(conn.send_command("show ip interface brief"))
    # 設定投入
    conn.send_config_set([
        "interface Loopback200",
        "description Created by Netmiko",
        "ip address 10.200.200.1 255.255.255.255",
    ])
    print(conn.send_command("show running-config interface Loopback200"))
    conn.save_config()
```

---

## 7. Ansible（エージェントレス構成管理）

### inventory.yml
```yaml
all:
  children:
    routers:
      hosts:
        R1:
          ansible_host: 192.168.99.1
        R2:
          ansible_host: 192.168.99.2
      vars:
        ansible_network_os: ios
        ansible_connection: network_cli
        ansible_user: admin
        ansible_password: Ccnp12345
```

### playbook.yml
```yaml
---
- name: Configure loopback on routers
  hosts: routers
  gather_facts: false
  tasks:
    - name: Create loopback interface
      cisco.ios.ios_config:
        lines:
          - description Managed by Ansible
          - ip address 10.250.250.1 255.255.255.255
        parents: interface Loopback250

    - name: Show interfaces
      cisco.ios.ios_command:
        commands:
          - show ip interface brief
      register: result

    - name: Print output
      ansible.builtin.debug:
        var: result.stdout_lines
```

```bash
ansible-playbook -i inventory.yml playbook.yml
```

### Ansible の暗記ポイント
| 項目 | 内容 |
|------|------|
| アーキテクチャ | **エージェントレス**（対象機器に何も入れない） |
| 接続方法 | SSH（ネットワーク機器は `network_cli`） |
| 記述言語 | **YAML** |
| 構成 | Inventory（対象）/ Playbook（手順）/ Module（部品）/ Role |
| 特性 | **冪等性**（何回流しても同じ結果） |
| Push/Pull | **Push 型** |

### 構成管理ツールの比較（出る）
| ツール | エージェント | 言語 | Push/Pull |
|--------|-------------|------|-----------|
| **Ansible** | **不要** | **YAML** | Push |
| Puppet | **必要** | Puppet DSL（Ruby ベース） | **Pull** |
| Chef | **必要** | Ruby | **Pull** |
| SaltStack | 基本必要（agentless も可） | YAML | Push/Pull |

---

## 8. EEM（機器内で完結する自動化）

```cisco
! Gi0/1 が down したらログを残し、自動で復旧を試みる
event manager applet IF-DOWN-RECOVER
 event syslog pattern "Interface GigabitEthernet0/1, changed state to down"
 action 1.0 syslog msg "EEM: Gi0/1 went down, attempting recovery"
 action 2.0 cli command "enable"
 action 3.0 cli command "configure terminal"
 action 4.0 cli command "interface GigabitEthernet0/1"
 action 5.0 cli command "shutdown"
 action 6.0 cli command "no shutdown"
 action 7.0 cli command "end"
```
```cisco
show event manager policy registered
show event manager history events
debug event manager action cli
```

---

## 9. 関連用語（座学）

| 用語 | 要点 |
|------|------|
| **YANG** | データモデル記述言語。NETCONF/RESTCONF が扱うデータの「型定義」 |
| **モデル種別** | Native（ベンダ固有: Cisco-IOS-XE-native）/ OpenConfig / IETF（標準） |
| **Model-Driven Telemetry** | SNMP のポーリングに代わり、機器から**プッシュ**で送る監視方式 |
| **Cisco DNA Center / Catalyst Center** | エンタープライズの集中管理・自動化・保証 |
| **Intent-Based Networking** | 「意図」を宣言すると機器設定へ翻訳される考え方 |
| **CI/CD** | 設定をコード管理し、テスト→反映を自動化 |
| **Puppet/Chef の Pull 型** | エージェントが定期的にサーバへ取りに行く |

---

## 🔨 わざと壊す
| # | 壊し方 | 症状 | 確認 |
|---|--------|------|------|
| 1 | `no restconf` にする | curl が接続拒否 | `show ip http server status` |
| 2 | `aaa authorization exec default local` を消す | **401/403 が返る** | `show run \| include aaa` |
| 3 | URI のモジュール名を間違える | **404 Not Found** | URI を `ietf-interfaces:interfaces` に変えて比較 |
| 4 | ユーザの privilege を 1 にする | 403 / 設定変更できない | `show run \| include username` |
| 5 | JSON の括弧を 1 つ消す | **400 Bad Request** | エラーメッセージを読む練習 |

---

## ✅ 卒業条件
- [ ] NETCONF / RESTCONF のポートとデータ形式を即答できる
- [ ] curl で GET して JSON を取得できた
- [ ] curl または Python の PUT で**実際にホスト名を変えた**
- [ ] ncclient で `get-config` の XML を表示できた
- [ ] Ansible Playbook を 1 本書いて流した
- [ ] HTTP メソッドとステータスコードの表を書き出せる
- [ ] Ansible / Puppet / Chef の比較表を書き出せる
