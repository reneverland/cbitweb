# 宝塔面板部署指南

## 🎯 适用场景

如果你的服务器使用**宝塔面板（BT Panel）**安装的Nginx，请按照本指南操作。

**如何判断是否使用宝塔面板？**
- Nginx配置文件路径为 `/www/server/nginx/conf/nginx.conf`
- 有 `/www/server/` 目录
- 服务器安装了宝塔面板控制面板

---

## 📦 一键部署（推荐）

### 方式1：使用自动化脚本

```bash
# 克隆或更新代码
cd /www/wwwroot  # 或你的项目目录
git clone git@github.com:reneverland/cbitweb.git
cd cbitweb

# 运行自动化部署脚本
bash deploy-server.sh
```

脚本会自动：
- ✅ 检测宝塔面板
- ✅ 配置Nginx反向代理
- ✅ 部署Docker容器
- ✅ 使用正确的方式重启Nginx

---

## 🔧 手动部署步骤

### 1️⃣ 克隆代码

```bash
cd /www/wwwroot  # 宝塔默认网站目录
git clone git@github.com:reneverland/cbitweb.git
cd cbitweb
```

### 2️⃣ 配置Nginx

```bash
sudo bash setup-nginx.sh
```

脚本会自动：
- 检测到宝塔面板安装的Nginx
- 将配置文件放到 `/www/server/nginx/conf/vhost/cbitweb.conf`
- 使用 `nginx -s reload` 重启（宝塔兼容方式）

### 3️⃣ 部署Docker容器

```bash
# 拉取最新镜像
docker pull ghcr.io/reneverland/cbitweb:latest

# 停止旧容器（如果存在）
docker stop cbit-official-web 2>/dev/null || true
docker rm cbit-official-web 2>/dev/null || true

# 启动新容器
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/reneverland/cbitweb:latest
```

### 4️⃣ 在宝塔面板中重启Nginx

**方法A：命令行**
```bash
nginx -s reload
```

**方法B：宝塔面板界面**
1. 登录宝塔面板
2. 左侧菜单 → 软件商店 → Nginx
3. 点击"重载配置"或"重启"

---

## 🔍 验证部署

### 检查Docker容器

```bash
docker ps | grep cbit-official-web
```

应该看到容器正在运行，端口映射 `8080->80`

### 检查Nginx配置

```bash
# 查看配置文件
cat /www/server/nginx/conf/vhost/cbitweb.conf

# 测试配置
nginx -t
```

### 测试访问

```bash
# 测试Docker容器
curl -I http://localhost:8080

# 测试Nginx代理
curl -I http://localhost
```

---

## 🎨 宝塔面板可选配置

### 方式1：在宝塔面板中添加网站（推荐）

1. **登录宝塔面板**
2. **左侧菜单 → 网站 → 添加站点**
   - 域名：`cbit.cuhk.edu.cn`（或你的域名）
   - 目录：`/www/wwwroot/cbitweb`
   - PHP版本：纯静态（不需要PHP）
   - 创建FTP：否
   - 创建数据库：否

3. **配置反向代理**
   - 点击网站名称 → 反向代理
   - 添加反向代理：
     - 代理名称：`cbit-web`
     - 目标URL：`http://127.0.0.1:8080`
     - 发送域名：`$host`
     - 启用缓存：否
   - 添加API代理：
     - 代理名称：`cbit-api`
     - 代理路径：`/api/`
     - 目标URL：`http://113.106.62.42:9300/`
     - 启用缓存：否

4. **保存并重载Nginx**

### 方式2：使用我们的配置文件（已完成）

运行 `setup-nginx.sh` 后，配置文件已经放在：
```
/www/server/nginx/conf/vhost/cbitweb.conf
```

无需在宝塔面板中额外配置，直接使用即可。

---

## 🐛 常见问题

### 问题1：Nginx重启失败

**错误信息**：
```
Job for nginx.service invalid.
Job for nginx.service failed because the control process exited with error code.
```

**原因**：宝塔面板的Nginx不是通过systemd管理的。

**解决方法**：
```bash
# 使用nginx命令重启
nginx -s reload

# 或者在宝塔面板中重启
```

### 问题2：配置文件位置不对

**检查配置文件是否存在**：
```bash
ls -la /www/server/nginx/conf/vhost/cbitweb.conf
```

**如果不存在，手动复制**：
```bash
sudo cp nginx-reverse-proxy.conf /www/server/nginx/conf/vhost/cbitweb.conf
nginx -t
nginx -s reload
```

### 问题3：端口8080被占用

**检查端口占用**：
```bash
netstat -tunlp | grep 8080
```

**更换端口**（例如改为8081）：
```bash
# 停止旧容器
docker stop cbit-official-web && docker rm cbit-official-web

# 使用新端口启动
docker run -d --name cbit-official-web -p 8081:80 --restart unless-stopped ghcr.io/reneverland/cbitweb:latest

# 修改Nginx配置中的端口
sed -i 's/127.0.0.1:8080/127.0.0.1:8081/g' /www/server/nginx/conf/vhost/cbitweb.conf

# 重载Nginx
nginx -s reload
```

### 问题4：API调用失败（CORS错误）

确保Nginx配置中包含API反向代理配置，并且OPTIONS预检请求处理正确。

**验证API代理**：
```bash
curl -I http://localhost/api/
```

应该返回从 `113.106.62.42:9300` 代理的响应。

### 问题5：Docker容器无法访问外部API

**检查DNS设置**：
```bash
docker exec cbit-official-web cat /etc/resolv.conf
```

**如果DNS有问题，重新创建容器**：
```bash
docker stop cbit-official-web && docker rm cbit-official-web

docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --dns 8.8.8.8 \
  --dns 8.8.4.4 \
  --restart unless-stopped \
  ghcr.io/reneverland/cbitweb:latest
```

---

## 📋 宝塔面板特定命令

### 重启Nginx
```bash
# 推荐：重载配置
nginx -s reload

# 或者完全重启
/etc/init.d/nginx restart

# 或者在宝塔面板界面操作
```

### 查看Nginx日志
```bash
# 访问日志
tail -f /www/wwwlogs/cbitweb_access.log

# 错误日志
tail -f /www/wwwlogs/cbitweb_error.log

# 如果日志在标准位置
tail -f /var/log/nginx/cbitweb_access.log
tail -f /var/log/nginx/cbitweb_error.log
```

### 查看Nginx配置
```bash
# 主配置文件
cat /www/server/nginx/conf/nginx.conf

# 网站配置文件
cat /www/server/nginx/conf/vhost/cbitweb.conf

# 测试配置
nginx -t
```

---

## 🚀 快速命令参考

### 更新部署
```bash
cd /www/wwwroot/cbitweb
git pull origin main
bash deploy-server.sh
```

### 查看状态
```bash
# Docker容器状态
docker ps | grep cbit

# Nginx进程
ps aux | grep nginx

# 端口监听
netstat -tunlp | grep -E '80|8080'
```

### 日志查看
```bash
# Docker日志
docker logs -f cbit-official-web

# Nginx日志
tail -f /var/log/nginx/cbitweb_*.log
```

---

## 📞 需要帮助？

如果遇到问题：
1. 检查 `QUICK_FIX.md` 快速修复指南
2. 查看 `NGINX_SETUP.md` 详细Nginx配置说明
3. 查看Docker容器日志：`docker logs cbit-official-web`
4. 查看Nginx错误日志：`tail -f /var/log/nginx/cbitweb_error.log`

---

## ✅ 验证清单

部署完成后，请验证以下项目：

- [ ] Docker容器正在运行（`docker ps | grep cbit`）
- [ ] Nginx配置测试通过（`nginx -t`）
- [ ] 可以访问主页（`curl http://localhost`）
- [ ] 可以访问Docker容器（`curl http://localhost:8080`）
- [ ] ICSF按钮显示正常
- [ ] 聊天功能可以正常使用
- [ ] 主题切换正常
- [ ] 语言切换正常

---

🎉 祝部署顺利！

