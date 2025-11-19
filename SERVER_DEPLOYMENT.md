# 服务器部署指南

## 📍 快速部署流程

### 1️⃣ 在服务器上克隆/更新代码

```bash
# 如果是第一次部署
git clone git@github.com:reneverland/cbitweb.git
cd cbitweb

# 如果已经有项目，只需更新
cd cbitweb
git pull origin main
```

### 2️⃣ 运行Nginx设置脚本

**重要**：必须在项目根目录运行！

```bash
# 确保在项目根目录
pwd  # 应该显示: /path/to/cbitweb

# 运行脚本（需要sudo权限）
sudo bash setup-nginx.sh
```

脚本会自动：
- ✅ 检查并安装Nginx（如果未安装）
- ✅ 配置反向代理到Docker容器（8080端口）
- ✅ 配置API反向代理（解决CORS问题）
- ✅ 测试并重启Nginx

### 3️⃣ 部署Docker容器

```bash
# 停止并删除旧容器（如果存在）
docker stop cbit-official-web 2>/dev/null || true
docker rm cbit-official-web 2>/dev/null || true

# 拉取最新镜像
docker pull ghcr.io/reneverland/cbitweb:latest

# 运行新容器
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/reneverland/cbitweb:latest
```

### 4️⃣ 验证部署

```bash
# 检查Docker容器状态
docker ps | grep cbit-official-web

# 检查Nginx状态
sudo systemctl status nginx

# 测试网站访问
curl -I http://localhost:8080
curl -I http://localhost
```

---

## 🔧 常见问题处理

### Nginx配置文件位置不存在

如果遇到 `cp: cannot create regular file '/etc/nginx/conf.d/cbitweb.conf': No such file or directory`：

```bash
# 脚本会自动创建目录，如果还有问题，手动创建：
sudo mkdir -p /etc/nginx/conf.d
sudo bash setup-nginx.sh
```

### API 405错误

确保使用最新的setup-nginx.sh脚本（已修复OPTIONS预检问题）：

```bash
cd cbitweb
git pull origin main
sudo bash setup-nginx.sh
```

### Docker镜像拉取失败

```bash
# 检查GitHub Container Registry登录状态
echo $GITHUB_TOKEN | docker login ghcr.io -u reneverland --password-stdin

# 或使用GitHub Personal Access Token
docker login ghcr.io -u reneverland
```

---

## 📦 完整部署脚本（一键执行）

创建 `deploy.sh` 文件，然后运行 `bash deploy.sh`：

```bash
#!/bin/bash
set -e

echo "🚀 开始部署CBIT官网..."

# 1. 更新代码
echo "📥 拉取最新代码..."
git pull origin main

# 2. 配置Nginx
echo "⚙️  配置Nginx反向代理..."
sudo bash setup-nginx.sh

# 3. 停止旧容器
echo "🛑 停止旧容器..."
docker stop cbit-official-web 2>/dev/null || true
docker rm cbit-official-web 2>/dev/null || true

# 4. 拉取新镜像
echo "📦 拉取最新Docker镜像..."
docker pull ghcr.io/reneverland/cbitweb:latest

# 5. 启动新容器
echo "🐳 启动Docker容器..."
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/reneverland/cbitweb:latest

# 6. 验证
echo "✅ 验证部署..."
sleep 3
docker ps | grep cbit-official-web
curl -I http://localhost:8080

echo "🎉 部署完成！"
echo "访问: http://your-server-ip"
```

---

## 🌐 访问网站

- **直接访问Docker**: `http://your-server-ip:8080`
- **通过Nginx代理**: `http://your-server-ip` 或 `https://cbit.cuhk.edu.cn`

---

## 📝 端口说明

- **8080**: Docker容器端口（内部Nginx提供静态文件）
- **80/443**: 主机Nginx端口（反向代理到8080，同时代理API到113.106.62.42:9300）

---

## 🔄 更新流程

每次有新代码推送到GitHub后：

```bash
cd cbitweb
git pull origin main
sudo bash setup-nginx.sh
docker stop cbit-official-web && docker rm cbit-official-web
docker pull ghcr.io/reneverland/cbitweb:latest
docker run -d --name cbit-official-web -p 8080:80 --restart unless-stopped ghcr.io/reneverland/cbitweb:latest
```

或者使用一键脚本：
```bash
bash deploy.sh
```

