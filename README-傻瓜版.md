# Origin MCP 傻瓜版迁移包

这份包用于在另一台 Windows 电脑上安装并使用 `origin-mcp`，让 HanaAgent/OpenHanako 可以控制 Origin/OriginPro 画图、导入数据、导出图片和保存 `.opju` 项目。

## 你会得到什么

包内主要内容：

```text
origin-mcp-transfer-kit/
├─ origin-mcp-src/                 # 已修过的 origin-mcp 源码版
├─ scripts/
│  ├─ install-origin-mcp.ps1        # 一键安装 Python 包并构建 Origin App
│  ├─ build-origin-app.ps1          # 只重建 Origin App 按钮
│  └─ check-origin-mcp.ps1          # 检查 Python/Hana/Origin 路径
├─ hana-config-example/
│  └─ origin-mcp-connector.example.json
├─ docs/
│  └─ AI-HANDOFF.md                 # 给 AI 助手看的说明
└─ README-傻瓜版.md                 # 本文件
```

## 最低要求

新电脑需要：

1. Windows。
2. Origin 或 OriginPro，建议 2025b 或 2026。
3. HanaAgent/OpenHanako。
4. Python 3.10+，推荐 Python 3.12。

检查 Python：

```powershell
python --version
```

如果提示找不到 Python，先安装 Python，再继续。

## 第一步：解压

把整个压缩包解压到一个路径，例如：

```text
C:\Users\你的用户名\Desktop\origin-mcp-transfer-kit
```

路径里尽量不要有奇怪符号。中文用户名通常没问题，但如果后续报路径错误，建议放到：

```text
C:\origin-mcp-transfer-kit
```

## 第二步：安装 origin-mcp

在解压后的目录里，右键空白处打开 PowerShell，执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-origin-mcp.ps1
```

它会做三件事：

1. 用当前 Python 安装源码版 `origin-mcp`。
2. 构建 Origin App 按钮文件夹。
3. 复制 `Origin MCP Bridge Start/Stop` 到 Origin Apps 目录。

成功时你会看到类似：

```text
origin-mcp import OK
Copied App folders into Origin Apps folder
```

## 第三步：配置 HanaAgent/OpenHanako MCP

打开 Hana 的 MCP 配置文件：

```text
%USERPROFILE%\.hanako\plugin-data\mcp\config.json
```

如果没有这个文件，可以先在 Hana 设置里打开 MCP 功能，或手动创建目录和文件。

把下面这段 connector 加到 `connectors` 数组里。注意替换两个路径：

- `command`：新电脑真实的 `python.exe` 路径
- `ORIGIN_MCP_BRIDGE_STATUS`：新电脑 `origin-mcp-src` 里的状态文件路径

示例：

```json
{
  "id": "origin-mcp",
  "name": "Origin MCP",
  "description": "Origin/OriginPro local bridge via origin-mcp",
  "transport": "stdio",
  "url": "",
  "command": "C:\\Users\\你的用户名\\AppData\\Local\\Programs\\Python\\Python312\\python.exe",
  "args": ["-m", "origin_mcp"],
  "cwd": "",
  "env": {
    "ORIGIN_MCP_BRIDGE_STATUS": "C:\\Users\\你的用户名\\Desktop\\origin-mcp-transfer-kit\\origin-mcp-src\\origin-bridge.status.txt"
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

更省事：打开包里的：

```text
hana-config-example\origin-mcp-connector.example.json
```

复制进去后改路径。

改完后重启 HanaAgent。

## 第四步：安装/注册 Origin App 按钮

安装脚本会把按钮文件夹复制到：

```text
%LOCALAPPDATA%\OriginLab\Apps
```

但有些 Origin 版本不会仅凭文件夹显示在 Apps Gallery。若 Apps Gallery 里看不到：

- `Origin MCP Bridge Start`
- `Origin MCP Bridge Stop`

就需要打包 OPX 并拖入 Origin。

### 方式 A：如果 Apps Gallery 已出现按钮

直接跳过本步。

### 方式 B：如果 Apps Gallery 没出现按钮

打开 Origin 的 Command Window，执行包里生成的两行 `mkOPX` 命令。

命令文件位置：

```text
origin-mcp-src\build\origin-app\mkopx-command.txt
```

里面类似：

```labtalk
mkOPX app:="Origin MCP Bridge Start" opx:="...\Origin MCP Bridge Start.opx";
mkOPX app:="Origin MCP Bridge Stop" opx:="...\Origin MCP Bridge Stop.opx";
```

执行后会生成两个 `.opx` 文件。把它们拖进 Origin 窗口安装，然后重启 Origin。

## 第五步：正常使用流程

每次使用时：

1. 打开 HanaAgent。
2. 打开 Origin。
3. 在 Origin Apps Gallery 点 `Origin MCP Bridge Start`。
4. 回到 Hana，让 AI 操作 Origin。
5. 用完后在 Origin Apps Gallery 点 `Origin MCP Bridge Stop`。
6. 再退出 Origin。

不要直接关闭 Origin。否则可能提示还有脚本在运行。

## 常见坑和解决办法

### 1. Hana 里看不到 origin-mcp 工具

原因可能是 Hana 没重启，或 `config.json` 写错。

解决：

1. 检查 JSON 是否合法。
2. 检查 `command` 是否是真实存在的 `python.exe`。
3. 重启 HanaAgent。
4. 让 AI 查询 MCP connector 状态。

### 2. Apps Gallery 没有 Start/Stop

原因：App 文件夹复制了，但 Origin 没注册。

解决：

1. 用 Origin Command Window 执行 `mkOPX` 两行命令。
2. 把生成的 `.opx` 拖进 Origin。
3. 重启 Origin。

### 3. 退出 Origin 时提示脚本还在运行

原因：Bridge 还在运行。

解决：

1. 点弹窗 `确定`。
2. 回到 Apps Gallery。
3. 点 `Origin MCP Bridge Stop`。
4. 再退出 Origin。

### 4. Bridge Start 点了没反应

可能原因：Origin 内置 Python 缺依赖，或路径没读到源码。

解决：

1. 看状态文件：`origin-mcp-src\origin-bridge.status.txt`。
2. 看临时握手文件：`%TEMP%\origin-mcp\bridge.json`。
3. 如果没有 `bridge.json`，说明 bridge 没起来。
4. 重新执行 `scripts\build-origin-app.ps1`，再点 Start。

### 5. 报 `Data file contains no rows`

旧版 `origin-mcp` 曾有导表兼容问题。本迁移包里的源码版已修复。

解决：

1. 确保 `pip install -e origin-mcp-src` 成功。
2. 确保 Origin App 也用的是本包里的新版源码。
3. 如果刚更新过源码，先点 `Origin MCP Bridge Stop`，再运行 `scripts\build-origin-app.ps1`，再点 Start。

### 6. 报 `'StringDtype' object has no attribute 'char'`

也是旧版写表路径问题。本包已修。

解决同上：重装源码版，并重建 Origin App。

### 7. Stop 按钮提示没有 handshake

说明 bridge 没在运行，或已经停了。

解决：通常不用管。需要用时再点 Start。

### 8. Python 安装了，但 Hana 启动失败

可能 Hana 配置里的 Python 路径不是装了 `origin-mcp` 的那个 Python。

解决：

```powershell
python -c "import sys; print(sys.executable)"
python -c "import origin_mcp; print(origin_mcp.__file__)"
```

把第一行输出的路径填到 Hana MCP connector 的 `command`。

## 推荐验证

配置好后，让 AI 做这几个验证：

1. 查询 MCP connector 状态，应为 `running`，工具数量约 60+。
2. 点 Origin App `Start` 后，检查 `%TEMP%\origin-mcp\bridge.json` 是否存在。
3. 让 AI 导入一个简单 CSV。
4. 让 AI 画一张 line+symbol 图并导出 PNG。
5. 让 AI 保存一个 `.opju`。

## 安全提醒

Bridge 默认只监听本机 `127.0.0.1`，并使用 token 鉴权。

不要设置：

```text
ORIGIN_MCP_BRIDGE_NO_AUTH
```

除非你完全信任本机所有进程。
