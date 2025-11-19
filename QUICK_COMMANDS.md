# 快速命令速查卡

## 🚀 一键部署（所有环境）

```bash
cd cbitweb
bash deploy-server.sh
```

---

## 📦 标准部署流程

### 1. 克隆/更新代码
```bash
git clone git@github.com:reneverland/cbitweb.git
cd cbitweb
# 或更新: git pull origin main
```

### 2. 配置Nginx
```bash
sudo bash setup-nginx.sh
```

### 3. 部署Docker
```bash
docker pull ghcr.io/reneverland/cbitweb:latest
docker stop cbit-official-web 2>/dev/null || true
docker rm cbit-official-web 2>/dev/null || true
docker run -d --name cbit-official-web -p 8080:80 --restart unless-stopped ghcr.io/reneverland/cbitweb:latest
```

---

## 🎛️ Nginx管理命令

### 标准Linux系统
```bash
sudo systemctl reload nginx      # 重载配置
sudo systemctl restart nginx     # 重启服务
sudo systemctl status nginx      # 查看状态
nginx -t                         # 测试配置
```

### 宝塔面板
```bash
nginx -s reload                  # 重载配置（推荐）
/etc/init.d/nginx restart        # 重启服务
nginx -t                         # 测试配置
```

或在宝塔面板界面：**软件商店 → Nginx → 重载配置**

---

## 🐳 Docker管理命令

```bash
# 查看容器状态
docker ps | grep cbit

# 查看容器日志
docker logs -f cbit-official-web

# 重启容器
docker restart cbit-official-web

# 停止并删除容器
docker stop cbit-official-web
docker rm cbit-official-web

# 进入容器
docker exec -it cbit-official-web sh
```

---

## 📋 检查服务状态

```bash
# 检查端口监听
netstat -tunlp | grep -E '80|8080'
# 或
ss -tulpn | grep -E '80|8080'

# 测试Docker容器
curl -I http://localhost:8080

# 测试Nginx代理
curl -I http://localhost

# 测试API代理
curl -I http://localhost/api/
```

---

## 📊 查看日志

```bash
# Docker容器日志
docker logs -f cbit-official-web

# Nginx访问日志
tail -f /var/log/nginx/cbitweb_access.log

# Nginx错误日志
tail -f /var/log/nginx/cbitweb_error.log

# 宝塔面板日志路径（如果不同）
tail -f /www/wwwlogs/cbitweb_access.log
tail -f /www/wwwlogs/cbitweb_error.log
```

---

## 🔧 配置文件位置

### 标准Linux
```bash
# Ubuntu/Debian
/etc/nginx/sites-available/cbitweb
/etc/nginx/sites-enabled/cbitweb

# CentOS/RHEL
/etc/nginx/conf.d/cbitweb.conf
```

### 宝塔面板
```bash
/www/server/nginx/conf/vhost/cbitweb.conf
```

### 编辑配置后重载
```bash
# 编辑配置
sudo nano /path/to/cbitweb.conf

# 测试配置
nginx -t

# 重载配置
nginx -s reload  # 或 sudo systemctl reload nginx
```

---

## 🔄 快速更新部署

```bash
cd cbitweb
git pull origin main
docker pull ghcr.io/reneverland/cbitweb:latest
docker stop cbit-official-web && docker rm cbit-official-web
docker run -d --name cbit-official-web -p 8080:80 --restart unless-stopped ghcr.io/reneverland/cbitweb:latest
nginx -s reload
```

---

## 🐛 常见问题快速修复

### Docker容器无法启动
```bash
docker logs cbit-official-web
docker rm cbit-official-web
docker run -d --name cbit-official-web -p 8080:80 --restart unless-stopped ghcr.io/reneverland/cbitweb:latest
```

### Nginx配置错误
```bash
nginx -t                  # 查看具体错误
nginx -s reload           # 修复后重载
```

### 端口被占用
```bash
# 查找占用进程
lsof -i :8080
# 或
netstat -tulpn | grep 8080

# 使用不同端口
docker run -d --name cbit-official-web -p 8081:80 --restart unless-stopped ghcr.io/reneverland/cbitweb:latest
```

### API CORS错误
```bash
# 确保Nginx代理配置正确
curl -I http://localhost/api/

# 重新运行配置脚本
sudo bash setup-nginx.sh
```

---

## 🎯 验证部署

```bash
# 完整验证脚本
echo "=== 检查Docker ==="
docker ps | grep cbit

echo "=== 检查Nginx ==="
nginx -t
ps aux | grep nginx | grep -v grep

echo "=== 测试访问 ==="
curl -I http://localhost:8080
curl -I http://localhost

echo "=== 检查日志 ==="
docker logs --tail 10 cbit-official-web
```

---

## 📱 访问地址

- **直接访问Docker**: `http://your-ip:8080`
- **通过Nginx代理**: `http://your-ip` 或 `http://your-domain.com`
- **ICSF会议**: 点击右上角 📅 ICSF 按钮

---

## 📚 详细文档

- **宝塔面板部署**: `BT_PANEL_SETUP.md`
- **服务器部署**: `SERVER_DEPLOYMENT.md`
- **Nginx配置**: `NGINX_SETUP.md`
- **快速修复**: `QUICK_FIX.md`
- **总体说明**: `DEPLOYMENT.md`

---

## ⚡ 超快速部署（复制粘贴）

```bash
# 完整的一键部署命令（全新服务器）
git clone git@github.com:reneverland/cbitweb.git && \
cd cbitweb && \
sudo bash setup-nginx.sh && \
docker pull ghcr.io/reneverland/cbitweb:latest && \
docker run -d --name cbit-official-web -p 8080:80 --restart unless-stopped ghcr.io/reneverland/cbitweb:latest && \
echo "✅ 部署完成！访问 http://$(hostname -I | awk '{print $1}')"
```

---

🎉 **收藏本页，随时查阅！**

