# CBIT Official Website

<div align="center">

<img src="public/sources/logo3@2x.png" alt="CBIT Logo" width="200"/>

### 香港中文大学(深圳) 区块链与智能科技研究中心官方网站

**CUHK-Shenzhen Blockchain and Intelligent Technology Research Center**

[![Build Status](https://github.com/reneverland/cbitweb/workflows/CI/badge.svg)](https://github.com/reneverland/cbitweb/actions)
[![Docker Build](https://github.com/reneverland/cbitweb/workflows/Docker%20Build%20and%20Push/badge.svg)](https://github.com/reneverland/cbitweb/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Vue 3](https://img.shields.io/badge/Vue-3.4.21-4FC08D?logo=vue.js)](https://vuejs.org/)
[![Vite](https://img.shields.io/badge/Vite-5.1.5-646CFF?logo=vite)](https://vitejs.dev/)
[![GitHub last commit](https://img.shields.io/github/last-commit/reneverland/cbitweb)](https://github.com/reneverland/cbitweb/commits/main)
[![GitHub stars](https://img.shields.io/github/stars/reneverland/cbitweb?style=social)](https://github.com/reneverland/cbitweb)

[English](README.md) | [中文文档](README_zh.md) | [Live Demo](https://cbit.cuhk.edu.cn)

</div>

---

## 📋 目录

- [项目简介](#-项目简介)
- [核心功能](#-核心功能)
- [技术栈](#-技术栈)
- [系统架构](#-系统架构)
- [快速开始](#-快速开始)
- [部署指南](#-部署指南)
- [项目结构](#-项目结构)
- [开发指南](#-开发指南)
- [贡献指南](#-贡献指南)
- [许可证](#-许可证)

---

## 🎯 项目简介

CBIT官方网站是一个现代化的研究中心展示平台，采用**对话式UI**设计理念，集成了真实的**AI智能助手**，为访问者提供交互式的信息获取体验。

### ✨ 项目亮点

- 🤖 **真实AI集成** - 基于Dify平台的智能问答系统
- 💬 **创新交互** - 对话式界面，突破传统官网设计
- 🌐 **多语言支持** - 中英文双语无缝切换
- 🎨 **现代化UI** - Tailwind CSS + 精美动画
- 📱 **响应式设计** - 完美适配各种设备
- 🐳 **容器化部署** - Docker + CI/CD自动化
- 🔒 **安全可靠** - HTTPS + Nginx反向代理

---

## 🚀 核心功能

### 智能对话系统
- **AI助手** - 实时回答关于研究中心的问题
- **自动建议** - 智能推荐相关问题
- **上下文理解** - 多轮对话记忆
- **快速问答** - 预设常见问题快捷入口

### 用户体验
- **🌓 主题切换** - 深色/浅色模式
- **🌍 语言切换** - 中文/英文界面
- **✨ 流畅动画** - 丝滑的交互效果
- **📱 响应式** - 移动端完美适配

### 内容展示
- **👥 团队介绍** - 核心成员展示（带头像大图预览）
- **📅 ICSF会议** - 2016-2024历届会议记录
- **🎯 研究项目** - 分类展示研究方向
- **📰 最新动态** - 研究中心新闻资讯

---

## 🛠️ 技术栈

### 前端框架
- **[Vue 3](https://vuejs.org/)** `v3.4.21` - 渐进式JavaScript框架
  - Composition API - 组合式API
  - Reactivity System - 响应式系统
  - SFC (Single File Components) - 单文件组件

### 构建工具
- **[Vite](https://vitejs.dev/)** `v5.1.5` - 下一代前端构建工具
  - ESBuild - 快速编译
  - HMR - 热模块替换
  - Multi-page Support - 多页面应用支持

### UI框架
- **[Tailwind CSS](https://tailwindcss.com/)** `v3.4.1` - 实用优先的CSS框架
  - JIT Mode - 即时编译
  - Dark Mode - 深色模式支持
  - Responsive Design - 响应式设计

### HTTP客户端
- **[Axios](https://axios-http.com/)** `v1.6.7` - Promise 基础的HTTP客户端
  - Interceptors - 请求/响应拦截
  - Auto Transform - 自动转换
  - Timeout - 超时处理

### 图标库
- **[RemixIcon](https://remixicon.com/)** - 开源图标系统

### 开发工具
- **PostCSS** `v8.4.35` - CSS转换工具
- **Autoprefixer** `v10.4.18` - CSS前缀自动添加

---

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────────────────┐
│                         用户浏览器                            │
│                    (HTTPS: cbit.cuhk.edu.cn)                │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ↓
┌─────────────────────────────────────────────────────────────┐
│                    Nginx (反向代理)                          │
│  ┌─────────────────┐              ┌────────────────────┐   │
│  │  Static Assets  │              │   API Proxy        │   │
│  │   (Vue SPA)     │              │  /api/* → :9300    │   │
│  │   Port: 80/443  │              │  CORS Headers      │   │
│  └─────────────────┘              └────────────────────┘   │
└─────────────┬───────────────────────────┬───────────────────┘
              │                           │
              ↓                           ↓
┌─────────────────────────┐   ┌──────────────────────────────┐
│   Docker Container      │   │   External API Server        │
│   ┌─────────────────┐   │   │   (Dify Platform)            │
│   │  Nginx:alpine   │   │   │   http://113.106.62.42:9300  │
│   │  Serve Vue App  │   │   │                              │
│   │  Port: 8080     │   │   │  - cbit-official endpoint    │
│   └─────────────────┘   │   │  - renprofile endpoint       │
└─────────────────────────┘   └──────────────────────────────┘
              │
              ↓
┌─────────────────────────────────────────────────────────────┐
│                   GitHub Actions CI/CD                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   CI Test   │  │ Build Image │  │ Push to GHCR        │ │
│  │   npm test  │→ │ Docker Build│→ │ ghcr.io/reneverland │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 技术架构特点

#### 前端层
- **Vue 3 SPA** - 单页面应用，动态路由
- **Multi-page Support** - 支持多个入口页面（index.html, profile.html）
- **Responsive Design** - 移动优先的响应式设计
- **Progressive Enhancement** - 渐进式增强

#### 中间层
- **Nginx Reverse Proxy** - 反向代理，处理静态资源和API转发
- **CORS Handling** - 跨域资源共享处理
- **SSL/TLS Termination** - HTTPS加密终止
- **Gzip Compression** - Gzip压缩优化传输

#### 后端层
- **Docker Containerization** - 容器化部署
- **Multi-stage Build** - 多阶段构建优化镜像大小
- **Health Check** - 健康检查机制
- **Auto Restart** - 自动重启策略

#### CI/CD层
- **GitHub Actions** - 自动化构建和部署
- **Docker Registry** - GitHub Container Registry (GHCR)
- **Automated Testing** - 自动化测试流程

---

## ⚡ 快速开始

### 前置要求

- **Node.js** >= 18.x
- **npm** >= 9.x 或 **pnpm** >= 8.x
- **Docker** >= 20.x (可选，用于容器化部署)
- **Git** >= 2.x

### 本地开发

```bash
# 1. 克隆仓库
git clone git@github.com:reneverland/cbitweb.git
cd cbitweb

# 2. 安装依赖
npm install

# 3. 启动开发服务器
npm run dev

# 4. 访问网站
# 打开浏览器访问 http://localhost:3000
```

### 构建生产版本

```bash
# 构建
npm run build

# 预览构建结果
npm run preview
```

---

## 🐳 部署指南

### Docker 部署（推荐）

#### 方式1：使用预构建镜像

```bash
# 拉取最新镜像
docker pull ghcr.io/reneverland/cbitweb:latest

# 运行容器
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/reneverland/cbitweb:latest
```

#### 方式2：本地构建

```bash
# 构建镜像
docker build -t cbitweb:latest .

# 运行容器
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  cbitweb:latest
```

#### 使用 Docker Compose

```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### Nginx 反向代理配置

详细配置请参考：
- [NGINX_SETUP.md](NGINX_SETUP.md) - 完整的Nginx配置指南
- [BT_PANEL_SETUP.md](BT_PANEL_SETUP.md) - 宝塔面板部署指南
- [SERVER_DEPLOYMENT.md](SERVER_DEPLOYMENT.md) - 服务器部署完整流程

#### 快速配置

```bash
# 运行自动化配置脚本
sudo bash setup-nginx.sh

# 或使用完整部署脚本
bash deploy-server.sh
```

### 环境变量

项目支持以下环境变量：

```bash
# API配置
VITE_API_BASE_URL=https://your-api-server.com
VITE_API_KEY=your-api-key

# 部署配置
PORT=3000
NODE_ENV=production
```

---

## 📁 项目结构

```
cbitweb/
├── .github/                  # GitHub配置
│   └── workflows/           # CI/CD工作流
│       ├── ci.yml          # 持续集成
│       └── docker-build.yml # Docker镜像构建
├── public/                  # 静态资源
│   ├── sources/            # 图片、文档等
│   │   ├── ICSF/          # ICSF会议资源
│   │   ├── team/          # 团队照片
│   │   └── *.png          # Logo等图片
│   └── favicon.ico
├── src/                     # 源代码
│   ├── components/         # Vue组件
│   │   ├── ChatBubble.vue # 聊天气泡组件
│   │   └── InputBox.vue   # 输入框组件
│   ├── services/           # API服务
│   │   ├── api.js         # 主页API
│   │   └── renprofile-api.js # Profile页API
│   ├── locales/            # 国际化
│   │   └── index.js       # i18n配置
│   ├── App.vue             # 主应用组件
│   ├── ProfileApp.vue      # Profile页面组件
│   └── main.js             # 入口文件
├── index.html               # 主页入口
├── profile.html             # Profile页入口
├── vite.config.js          # Vite配置
├── tailwind.config.js      # Tailwind配置
├── postcss.config.js       # PostCSS配置
├── Dockerfile              # Docker镜像构建
├── docker-compose.yml      # Docker Compose配置
├── nginx.conf              # Nginx配置
├── package.json            # 项目依赖
└── README.md               # 项目文档
```

---

## 💻 开发指南

### 代码规范

项目遵循以下代码规范：

- **Vue** - Vue.js 官方风格指南
- **JavaScript** - ES6+ 标准
- **CSS** - Tailwind CSS 实用类优先

### Git 提交规范

使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
feat: 新功能
fix: 修复bug
docs: 文档更新
style: 代码格式调整
refactor: 代码重构
test: 测试相关
chore: 构建/工具链更新
```

示例：
```bash
git commit -m "feat: add ICSF conference series dropdown"
git commit -m "fix: resolve Mixed Content error in production"
git commit -m "docs: update deployment guide for BT Panel"
```

### 开发工具推荐

- **IDE**: VS Code / WebStorm
- **插件**:
  - Volar (Vue Language Features)
  - Tailwind CSS IntelliSense
  - ESLint
  - Prettier

### 调试技巧

```bash
# 查看详细构建信息
npm run build -- --debug

# 分析包大小
npm run build -- --report

# 查看Docker容器日志
docker logs -f cbit-official-web

# 查看Nginx日志
tail -f /var/log/nginx/cbitweb_access.log
tail -f /var/log/nginx/cbitweb_error.log
```

---

## 🤝 贡献指南

我们欢迎所有形式的贡献！

### 贡献方式

1. **Fork** 本仓库
2. **创建** 特性分支 (`git checkout -b feature/AmazingFeature`)
3. **提交** 更改 (`git commit -m 'feat: add some AmazingFeature'`)
4. **推送** 到分支 (`git push origin feature/AmazingFeature`)
5. **开启** Pull Request

### 问题反馈

发现问题？请通过以下方式反馈：

- [GitHub Issues](https://github.com/reneverland/cbitweb/issues)
- 邮件: cooledward@outlook.com

### 文档贡献

帮助改进文档：

- 修复错别字
- 补充说明
- 翻译文档
- 添加示例

---

## 📄 许可证

本项目采用 **MIT License** 开源协议。

详见 [LICENSE](LICENSE) 文件。

---

## 👨‍💻 作者

**Ren CBIT**

- GitHub: [@reneverland](https://github.com/reneverland)
- Email: cooledward@outlook.com
- Website: [CBIT Research Center](https://cbit.cuhk.edu.cn)

---

## 🙏 致谢

感谢以下开源项目：

- [Vue.js](https://vuejs.org/) - 渐进式JavaScript框架
- [Vite](https://vitejs.dev/) - 下一代前端构建工具
- [Tailwind CSS](https://tailwindcss.com/) - 实用优先的CSS框架
- [Axios](https://axios-http.com/) - HTTP客户端
- [RemixIcon](https://remixicon.com/) - 开源图标库
- [Dify](https://dify.ai/) - AI应用开发平台

---

<div align="center">

**[⬆ 返回顶部](#cbit-official-website)**

Made with ❤️ by [Ren CBIT](https://github.com/reneverland)

</div>
