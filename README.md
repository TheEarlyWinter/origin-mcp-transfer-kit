# origin-mcp-transfer-kit

> Origin MCP 一键迁移包 —— 让 AI 助手通过 MCP 控制 Origin/OriginPro

## ⚠️ 声明

本项目完全由 AI 生成，不保证任何质量、可用性或安全性。如果你介意，请不要使用。

---

## 这是什么？

在新电脑上快速部署 [origin-mcp](https://github.com/Ge-Shun/origin-mcp) 的一站式工具包。包含：

- **origin-mcp 源码版**（已修复几个兼容性 bug）
- **一键安装脚本**
- **Origin App 按钮**（Bridge Start / Stop）
- **MCP 配置示例**
- **平台兼容性说明**

## 快速开始

```powershell
# 1. 解压后进入目录
cd origin-mcp-transfer-kit

# 2. 一键安装
powershell -ExecutionPolicy Bypass -File .\scripts\install-origin-mcp.ps1

# 3. 配置 MCP 连接器
# 见 README-傻瓜版.md 第三步
```

## 平台支持

| 平台 | 支持情况 |
|------|---------|
| [OpenHanako / HanaAgent](https://github.com/liliMozi/openhanako) | ✅ 完全支持（附配置示例） |
| 其他 MCP 客户端（Codex、Claude Code、Cursor 等） | ⚠️ 需自行配置，见[平台兼容性说明](https://github.com/TheEarlyWinter/origin-mcp-transfer-kit/blob/main/%E5%B9%B3%E5%8F%B0%E5%85%BC%E5%AE%B9%E6%80%A7%E8%AF%B4%E6%98%8E.md) |

## 详细文档

- [傻瓜版安装指南](https://github.com/TheEarlyWinter/origin-mcp-transfer-kit/blob/main/README-%E5%82%BB%E7%93%9C%E7%89%88.md) —— 面向不想看技术细节的用户
- [AI-HANDOFF](https://github.com/TheEarlyWinter/origin-mcp-transfer-kit/blob/main/docs/AI-HANDOFF.md) —— 给 AI 助手看的部署说明
- [平台兼容性说明](https://github.com/TheEarlyWinter/origin-mcp-transfer-kit/blob/main/%E5%B9%B3%E5%8F%B0%E5%85%BC%E5%AE%B9%E6%80%A7%E8%AF%B4%E6%98%8E.md)

## 原始项目

- [Ge-Shun/origin-mcp](https://github.com/Ge-Shun/origin-mcp) —— origin-mcp 上游项目
- [liliMozi/openhanako](https://github.com/liliMozi/openhanako) —— OpenHanako / HanaAgent
