# AI-HANDOFF：在新电脑部署 origin-mcp 给 HanaAgent/OpenHanako 使用

## 目标

帮助用户在另一台 Windows 电脑上部署 `origin-mcp`，使 HanaAgent/OpenHanako 可以通过 MCP 控制 Origin/OriginPro。

用户倾向：希望“傻瓜式”，少让用户手动输入复杂命令。必须避免 Python Console 路线，优先使用 Origin App 按钮 `Origin MCP Bridge Start/Stop`。

## 包结构

```text
origin-mcp-transfer-kit/
├─ origin-mcp-src/                 # 源码版 origin-mcp，包含本机修复
├─ scripts/
│  ├─ install-origin-mcp.ps1
│  ├─ build-origin-app.ps1
│  └─ check-origin-mcp.ps1
├─ hana-config-example/
│  └─ origin-mcp-connector.example.json
├─ docs/
│  └─ AI-HANDOFF.md
└─ README-傻瓜版.md
```

## 重要背景

本包不是纯 PyPI 版。它带了源码，因为当前机器上修过几个关键兼容问题：

1. `import_table` 改走 `_write_dataframe_to_worksheet()`，避免 OriginPro/Pandas 写入问题。
2. `append_table` 同样改走安全写入路径。
3. `_prepare_dataframe_for_origin()` 会把字符串/object 列转成安全 object，避免 `'StringDtype' object has no attribute 'char'`。
4. `_normalize_origin_start_col()` 避免 `c1 must not be <0`。

部署时请优先执行：

```powershell
pip install -e .\origin-mcp-src
```

不要只用 `pip install origin-mcp`，否则可能回到旧 bug。

## 部署步骤

### 1. 检查环境

需要：

- Windows
- Origin/OriginPro，推荐 2025b/2026
- HanaAgent/OpenHanako
- Python 3.10+，推荐 3.12

运行：

```powershell
python --version
python -c "import sys; print(sys.executable)"
```

记录 `sys.executable`，之后写入 Hana MCP connector 的 `command`。

### 2. 安装 Python 包

在 `origin-mcp-transfer-kit` 根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-origin-mcp.ps1
```

或手动：

```powershell
python -m pip install -e .\origin-mcp-src
python -c "import origin_mcp; print(origin_mcp.__file__)"
```

### 3. 构建并复制 Origin App

脚本会调用：

```powershell
python .\origin-mcp-src\scripts\build_origin_app.py --force --install
```

目标目录：

```text
%LOCALAPPDATA%\OriginLab\Apps\Origin MCP Bridge Start
%LOCALAPPDATA%\OriginLab\Apps\Origin MCP Bridge Stop
```

如果文件被占用，说明 Bridge 还在运行。让用户打开 Origin Apps Gallery，点 `Origin MCP Bridge Stop`，再重试。

### 4. 配置 Hana MCP

Hana 配置文件：

```text
%USERPROFILE%\.hanako\plugin-data\mcp\config.json
```

最小 connector：

```json
{
  "id": "origin-mcp",
  "name": "Origin MCP",
  "description": "Origin/OriginPro local bridge via origin-mcp",
  "transport": "stdio",
  "url": "",
  "command": "C:\\Path\\To\\python.exe",
  "args": ["-m", "origin_mcp"],
  "cwd": "",
  "env": {
    "ORIGIN_MCP_BRIDGE_STATUS": "C:\\path\\to\\origin-mcp-transfer-kit\\origin-mcp-src\\origin-bridge.status.txt"
  },
  "headers": {},
  "registryUrl": "",
  "timeout": 0,
  "authType": "none",
  "authorizationToken": "",
  "oauthClientId": "",
  "oauthClientSecret": "",
  "clientIdSource": "",
  "oauth": {
    "accessToken": "",
    "refreshToken": "",
    "tokenType": "",
    "tokenEndpoint": "",
    "scope": "",
    "expiresIn": 0,
    "expiresAt": 0,
    "obtainedAt": 0
  },
  "autoStart": true,
  "autoReconnect": true,
  "tools": []
}
```

注意：如果已有 `config.json` 很大，保留原有 `schemaVersion/global/mcp/connectors` 结构，只追加或替换 id 为 `origin-mcp` 的 connector。

修改后让用户重启 HanaAgent。

### 5. 注册 Origin App

如果 Apps Gallery 没有：

- `Origin MCP Bridge Start`
- `Origin MCP Bridge Stop`

让用户在 Origin Command Window 执行：

```text
origin-mcp-src\build\origin-app\mkopx-command.txt
```

文件里有两行 `mkOPX app:=... opx:=...`。执行后会生成两个 OPX。把 OPX 拖进 Origin 安装，再重启 Origin。

这一步不是 Python Console，不违反用户要求。

### 6. 使用流程

用户每次使用：

1. 启动 HanaAgent。
2. 启动 Origin。
3. Apps Gallery 点 `Origin MCP Bridge Start`。
4. AI 执行 Origin MCP 操作。
5. 用完 Apps Gallery 点 `Origin MCP Bridge Stop`。
6. 退出 Origin。

## 验证流程

在 HanaAgent 内：

1. 调用 MCP connector 状态工具。期望：`origin-mcp` running，toolCount 约 60+。
2. 用户点 Start 后，检查：

```text
%TEMP%\origin-mcp\bridge.json
origin-mcp-src\origin-bridge.status.txt
```

状态文件应有：

```json
"running": true
```

3. 用桥直接测：

```powershell
python -c "from origin_mcp.bridge_client import request_bridge; print(request_bridge('call_client', {'method':'new_project','args':[], 'kwargs': {'show': True}}))"
```

4. 画图 smoke test：导入简单 CSV，调用 `plot_table(kind='line_symbol')`，导出 PNG，保存 OPJU。

## 常见问题

### Hana connector stopped

检查：

- Hana 是否重启
- `config.json` JSON 是否合法
- `command` 是否存在
- `python -c "import origin_mcp"` 是否成功

### Origin App 看不到

原因：裸文件夹未注册。

处理：执行 `mkOPX` 两行命令，拖入 OPX 安装，重启 Origin。

### Bridge Start 后无 bridge.json

看：

```text
origin-mcp-src\origin-bridge.status.txt
```

如果缺依赖，通常里面会有 `last_error`。

### 更新源码后仍是旧行为

原因：Origin App 内部 vendored 了一份 `src`。只 `pip install -e` 不够。

处理：

1. 点 `Origin MCP Bridge Stop`。
2. 运行 `scripts\build-origin-app.ps1`。
3. 点 `Origin MCP Bridge Start`。

### 退出 Origin 卡住或提示脚本未结束

正常。Bridge 是前台服务脚本。

处理：点 `Origin MCP Bridge Stop` 再退出。

### `Data file contains no rows`

如果是普通 CSV/XLSX 仍报这个，优先怀疑新电脑没有用本包源码版或 App 没重建。

处理：

```powershell
python -m pip install -e .\origin-mcp-src
powershell -ExecutionPolicy Bypass -File .\scripts\build-origin-app.ps1
```

### `'StringDtype' object has no attribute 'char'`

同上，说明安全写表修复未生效。

## 行为边界

- 不要让用户走 Origin Python Console，除非用户明确同意。
- 不要关闭 bridge 鉴权，不设置 `ORIGIN_MCP_BRIDGE_NO_AUTH`。
- 不要在 Origin 未 Stop 时覆盖 App 文件，容易 WinError 32。
- 如果需要控制 Origin GUI，优先让用户点击 App 按钮，UIA 对 Origin 不稳定。

## 快速判断是否成功

成功状态：

- Hana connector `origin-mcp` running。
- Apps Gallery 有 Start/Stop。
- 点 Start 后 `%TEMP%\origin-mcp\bridge.json` 存在。
- `origin-bridge.status.txt` 里 `running: true`。
- 能导入数据、画图、导出 PNG、保存 OPJU。
