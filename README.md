<div align="center">

# 🔌 Origin MCP Transfer Kit

<p align="center">
  <b>Origin MCP 一键部署与无缝迁移套件 —— 让 AI 助手通过 MCP 协议轻松接管 Origin / OriginPro 科学绘图与数据分析</b>
</p>

[![HanaAgent / MCP](https://img.shields.io/badge/MCP-Protocol-8B5CF6?style=flat-square&logo=probot&logoColor=white)](https://github.com/liliMozi/openhanako)
[![Python 3.10+](https://img.shields.io/badge/Python-3.10%2B-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)
[![OriginPro 2021-2026](https://img.shields.io/badge/Support-OriginPro%202021--2026-orange?style=flat-square)](https://www.originlab.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)

</div>

---

> ⚠️ **声明**：本项目完全由 AI 生成，不保证任何质量、可用性或安全性。

---

## 📖 这是什么？

在新电脑或新环境中快速部署 [origin-mcp](https://github.com/Ge-Shun/origin-mcp) 的一站式工具包，解决上游依赖多、环境路径繁琐、跨平台配置复杂的问题。

通过本套件，可以让 **HanaAgent / OpenHanako**（以及其他支持 MCP 协议的 AI 助手）像操作本地命令一样，直接在后台指挥 Windows 桌面运行的 Origin / OriginPro 完成：
- 📊 **批量数据导入**：CSV、Excel、TXT 自动建表与列属性配置（X/Y/Z/Error Bar）
- 📈 **顶刊级图表绘制**：折线图、散点图、瀑布图、多层双 Y 轴图、等高线图、Nature / Science 主题配色
- 🔬 **高级曲线拟合**：多项式拟合、高斯分峰拟合（Gaussian）、洛伦兹拟合（Lorentzian）、Voigt 峰分解与统计分析
- 🖼️ **高清矢量导出**：自动渲染并导出无损 300~600 DPI 高清图（PNG / TIFF / PDF / EPS）
- 💾 **工程文件归档**：全自动保存为 `.opju` / `.opj` 工程文件

```
┌────────────────────────────────┐         ┌───────────────────────────┐         ┌─────────────────────────┐
│ AI Agent (HanaAgent / Claude)  ├─(MCP)─►│   origin_mcp (Stdio Server) │─(IPC)──►│ OriginPro (Windows 桌面)│
│ "导入光谱数据，画 Nature 风格"  │         │  (63+ 科学分析与绘图工具)    │         │ (实时在屏幕上绘图/拟合/导出)│
└────────────────────────────────┘         └───────────────────────────┘         └─────────────────────────┘
```

---

## 📦 目录结构

```text
origin-mcp-transfer-kit/
├─ origin-mcp-src/                 # 已深度修复兼容性的 origin-mcp 源码核心
├─ scripts/
│  ├─ install-origin-mcp.ps1       # 一键安装 Python 包并自动编译分发 Origin App 按钮
│  ├─ build-origin-app.ps1         # 独立重建 Origin App 工具栏按钮
│  └─ check-origin-mcp.ps1         # 自动化环境巡检（Python/Origin/Hana 路径诊断）
├─ hana-config-example/
│  └─ origin-mcp-connector.example.json # HanaAgent 连接器即插即用模板
├─ docs/
│  └─ AI-HANDOFF.md                # 专供 AI Agent 阅读与自动部署的上下文交接文档
├─ 平台兼容性说明.md
├─ README-傻瓜版.md
└─ README.md
```

---

## ⚡ 快速开始（5 分钟部署）

### 1. 环境准备
- **操作系统**：Windows 10 / 11 64 位
- **软件要求**：已安装 Origin / OriginPro（推荐 **2024b** 或 **2026**）
- **环境依赖**：Python 3.10+（推荐 Python 3.11 / 3.12）

### 2. 一键安装
克隆或下载本项目后，在项目根目录右键空白处打开 PowerShell 执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-origin-mcp.ps1
```

该脚本将全自动完成：
1. 以可编辑模式（`pip install -e`）安装修补版 `origin-mcp`；
2. 自动构建 Origin App 工具栏组件；
3. 将 `Origin MCP Bridge Start / Stop` 按钮部署至 Origin 官方 Apps 目录。

### 3. 配置 HanaAgent MCP 连接器
在 HanaAgent（或修改 `%USERPROFILE%\.hanako\plugin-data\mcp\config.json`）中启用连接器：

```json
{
  "id": "origin-mcp",
  "name": "Origin MCP",
  "transport": "stdio",
  "command": "C:\\Users\\你的用户名\\AppData\\Local\\Programs\\Python\\Python312\\python.exe",
  "args": ["-m", "origin_mcp"],
  "env": {
    "ORIGIN_MCP_BRIDGE_STATUS": "C:\\Users\\你的用户名\\AppData\\Local\\OriginLab\\Apps\\Origin MCP Bridge Start\\origin-bridge.status.txt"
  },
  "enabled": true,
  "autoStart": true
}
```

### 4. 启动与使用
1. 打开 Origin / OriginPro；
2. 点击右侧 Apps 工具栏中的 **「Origin MCP Bridge Start」** 图标（控制台显示 `serving requests cooperatively` 即表示桥接就绪）；
3. 在 Hana 对话框中直接发送绘图或拟合指令！

---

## 🎯 兼容性与版本推荐

| Origin 版本 | 支持状态 | 体验与特性说明 |
| :--- | :---: | :--- |
| **OriginPro 2024b (v10.1.5.132)** | 🌟 **强烈推荐 (Golden Target)** | 完美兼容、内置 Python 3.11、永久授权且**导出图片 100% 纯净无 Demo 水印** |
| **OriginPro 2025b (v10.2.5.212)** | ✅ **支持** | 完整支持所有 API；官方正版/学习版推荐，部分第三方补丁若遇 7 天水印可配合剪贴板模式使用 |
| **OriginPro 2026 / 2026b** | ✅ **支持** | 官方最新版本全功能支持 |
| **Origin 2021 ~ 2023** | ⚠️ **部分支持** | 支持基本绘图与 COM 调度，部分高级样式与现代 Python 接口可能受限 |

---

## 📚 详细文档

- 📘 [傻瓜版安装指南](README-傻瓜版.md) —— 面向不想深究命令行的科研工作者
- 🤖 [AI-HANDOFF 架构说明](docs/AI-HANDOFF.md) —— 专供 AI 助手理解与自我排错的技术手册
- 🧩 [平台兼容性说明](平台兼容性说明.md) —— 关于其他 MCP 客户端（Codex/Claude Code/Cursor）的适配建议

---

## 🔗 上游与鸣谢

- [Ge-Shun/origin-mcp](https://github.com/Ge-Shun/origin-mcp) —— origin-mcp 上游原始仓库
- [liliMozi/openhanako](https://github.com/liliMozi/openhanako) —— HanaAgent / OpenHanako 智能体平台
