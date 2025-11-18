# CBIT官网部署指南

## ✅ 已完成的配置

### 1. Docker容器化
- ✅ `Dockerfile` - 多阶段构建配置
- ✅ `nginx.conf` - Nginx服务器配置
- ✅ `docker-compose.yml` - Docker Compose配置
- ✅ `.dockerignore` - Docker忽略文件

### 2. GitHub CI/CD工作流
- ✅ `.github/workflows/ci.yml` - 持续集成工作流
- ✅ `.github/workflows/docker-build.yml` - Docker镜像构建和推送工作流

### 3. Git仓库
- ✅ Git仓库已初始化
- ✅ 所有文件已提交
- ✅ 远程仓库地址已配置：https://github.com/reneverland/cbitweb.git

## 📋 待完成：推送到GitHub

### 方式一：使用HTTPS + Personal Access Token（推荐）

1. **创建GitHub Personal Access Token**
   - 访问：https://github.com/settings/tokens
   - 点击 "Generate new token (classic)"
   - 勾选 `repo` 权限
   - 生成并复制token

2. **推送代码**
   ```bash
   cd /Users/Ren/Documents/CBITOfficialWeb
   git push -u origin main
   # 输入用户名：reneverland
   # 输入密码：粘贴你的Personal Access Token
   ```

### 方式二：使用SSH密钥

1. **生成SSH密钥**
   ```bash
   ssh-keygen -t ed25519 -C "cooledward@outlook.com"
   # 按提示操作，默认路径即可
   ```

2. **添加SSH密钥到GitHub**
   ```bash
   cat ~/.ssh/id_ed25519.pub
   # 复制输出内容
   ```
   - 访问：https://github.com/settings/keys
   - 点击 "New SSH key"
   - 粘贴公钥内容

3. **更改远程仓库URL为SSH**
   ```bash
   cd /Users/Ren/Documents/CBITOfficialWeb
   git remote set-url origin git@github.com:reneverland/cbitweb.git
   ```

4. **推送代码**
   ```bash
   git push -u origin main
   ```

## 🐳 本地Docker部署

### 使用Docker Compose（推荐）
```bash
cd /Users/Ren/Documents/CBITOfficialWeb
docker-compose up -d
```

访问：http://localhost:3000

### 使用Docker命令
```bash
# 构建镜像
docker build -t cbitweb:latest .

# 运行容器
docker run -d -p 3000:80 --name cbit-official-web cbitweb:latest
```

## 🚀 生产环境部署

### 1. 从GitHub拉取镜像
推送到GitHub后，CI/CD会自动构建Docker镜像并推送到GitHub Container Registry。

```bash
# 拉取镜像
docker pull ghcr.io/reneverland/cbitweb:latest

# 运行容器
docker run -d -p 80:80 --name cbit-web ghcr.io/reneverland/cbitweb:latest
```

### 2. 使用docker-compose
```bash
# 在服务器上创建docker-compose.yml
# 然后运行
docker-compose up -d
```

## 📝 GitHub Actions工作流说明

推送代码到GitHub后，会自动触发以下工作流：

### CI工作流（.github/workflows/ci.yml）
- 检出代码
- 安装Node.js依赖
- 构建项目
- 上传构建产物

### Docker工作流（.github/workflows/docker-build.yml）
- 构建Docker镜像
- 推送到GitHub Container Registry
- 自动打标签（latest, 分支名, commit SHA等）

## 🔍 验证部署

### 本地验证
```bash
# 检查容器状态
docker ps | grep cbit

# 查看容器日志
docker logs cbit-official-web

# 访问应用
curl http://localhost:3000
```

### 健康检查
Docker容器内置健康检查，每30秒自动检测一次。

## 📧 联系信息

- 作者：Ren CBIT
- GitHub：https://github.com/reneverland/
- 邮箱：cooledward@outlook.com

---

**注意事项：**
- API配置已内置在代码中，无需配置环境变量
- 所有静态资源已打包进Docker镜像
- 推荐使用docker-compose进行部署管理

