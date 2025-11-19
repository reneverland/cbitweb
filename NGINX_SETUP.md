# Nginx反向代理设置指南

## 问题说明

部署后遇到两个问题：
1. ✅ Docker容器运行正常（端口8080:80）
2. ❌ Chat API出现CORS错误（预检请求400失败）
3. ❌ SPA路由可能需要通过Nginx处理

## 解决方案：使用Nginx反向代理

### 架构说明

```
用户浏览器
    ↓
宿主机Nginx (80端口)
    ├── /api/* → 转发到 http://113.106.62.42:9300/* (外部API)
    └── /* → 转发到 http://127.0.0.1:8080 (Docker容器)
```

## 🚀 快速部署步骤

### 步骤1：确保Docker容器运行

```bash
# 检查容器状态
docker ps | grep cbit-official-web

# 如果没有运行，启动容器
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/reneverland/cbitweb:latest
```

### 步骤2：配置宿主机Nginx

#### 方法A：Ubuntu/Debian

```bash
# 1. 复制配置文件
sudo cp nginx-reverse-proxy.conf /etc/nginx/sites-available/cbitweb

# 2. 修改配置文件中的server_name
sudo nano /etc/nginx/sites-available/cbitweb
# 将 server_name 改为您的实际IP或域名
# server_name 10.20.217.43;  # 或者 yourdomain.com

# 3. 创建符号链接
sudo ln -s /etc/nginx/sites-available/cbitweb /etc/nginx/sites-enabled/

# 4. 测试配置
sudo nginx -t

# 5. 重启Nginx
sudo systemctl reload nginx
```

#### 方法B：CentOS/RHEL

```bash
# 1. 复制配置文件
sudo cp nginx-reverse-proxy.conf /etc/nginx/conf.d/cbitweb.conf

# 2. 修改配置文件中的server_name
sudo vi /etc/nginx/conf.d/cbitweb.conf
# 将 server_name 改为您的实际IP或域名

# 3. 测试配置
sudo nginx -t

# 4. 重启Nginx
sudo systemctl reload nginx
```

### 步骤3：验证部署

```bash
# 1. 检查Nginx状态
sudo systemctl status nginx

# 2. 检查Nginx日志
sudo tail -f /var/log/nginx/cbitweb_access.log
sudo tail -f /var/log/nginx/cbitweb_error.log

# 3. 测试API代理
curl -v http://10.20.217.43/api/api/apps/cbit-official/chat/completions

# 4. 测试主页
curl http://10.20.217.43/
```

## 📝 配置文件说明

### API路径映射

```nginx
# 前端调用: /api/api/apps/cbit-official/chat/completions
# Nginx转发: http://113.106.62.42:9300/api/apps/cbit-official/chat/completions
location /api/ {
    proxy_pass http://113.106.62.42:9300/;
    # ... CORS配置 ...
}
```

### CORS处理

Nginx配置中已包含完整的CORS头部：
- ✅ `Access-Control-Allow-Origin: *`
- ✅ `Access-Control-Allow-Methods: GET, POST, OPTIONS`
- ✅ `Access-Control-Allow-Headers: ...`
- ✅ 处理OPTIONS预检请求

## 🔧 故障排查

### 问题1：Nginx配置测试失败

```bash
# 查看详细错误
sudo nginx -t

# 常见问题：
# - 端口冲突：检查是否有其他服务占用80端口
sudo netstat -tlnp | grep :80

# - 权限问题：确保配置文件权限正确
sudo chmod 644 /etc/nginx/sites-available/cbitweb
```

### 问题2：API仍然报CORS错误

```bash
# 1. 检查Nginx是否正确代理
curl -v http://YOUR_IP/api/api/apps/cbit-official/chat/completions

# 2. 检查Nginx错误日志
sudo tail -50 /var/log/nginx/error.log

# 3. 检查前端是否使用了正确的URL
# 浏览器F12 -> Network -> 查看请求URL
# 应该是: http://YOUR_IP/api/api/apps/...
# 而不是: http://113.106.62.42:9300/api/apps/...
```

### 问题3：Docker容器无法访问

```bash
# 1. 检查容器状态
docker ps -a | grep cbit

# 2. 查看容器日志
docker logs cbit-official-web

# 3. 测试容器直接访问
curl http://127.0.0.1:8080

# 4. 检查端口映射
docker port cbit-official-web
```

### 问题4：profile.html访问问题

**症状**：点击石仁达的链接跳转到外部域名（如 `https://cbit.cuhk.edu.cn/profile.html`）

**原因**：
- `profile.html` 是独立的多页面应用
- 链接使用相对路径 `/profile.html`
- 在当前域名下访问是正常的（如 `http://10.20.217.43/profile.html`）

**解决方案**：
1. 确保Vite配置支持多页面（已配置）
2. 重新构建Docker镜像以包含profile.html
3. 在正确的域名下访问

**验证**：
```bash
# 检查Docker容器中是否有profile.html
docker exec cbit-official-web ls -la /usr/share/nginx/html/ | grep profile

# 直接访问profile页面
curl http://10.20.217.43/profile.html

# 应该看到HTML内容，而不是404
```

**注意**：如果您在 `https://cbit.cuhk.edu.cn` 访问网站，点击链接会跳转到 `https://cbit.cuhk.edu.cn/profile.html`，这是正常的。只需确保该域名下也部署了最新版本的代码。

## 📊 性能优化建议

### 启用Gzip压缩

已在配置中包含：
```nginx
gzip on;
gzip_vary on;
gzip_proxied any;
gzip_comp_level 6;
```

### 启用缓存

```nginx
# 为静态资源添加缓存控制
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    proxy_pass http://127.0.0.1:8080;
    proxy_cache_valid 200 1d;
    expires 7d;
}
```

### SSL/HTTPS配置（推荐）

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    # ... 其他配置同上 ...
}

server {
    listen 80;
    server_name yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

## 🔄 更新部署

当需要更新应用时：

```bash
# 1. 拉取最新镜像
docker pull ghcr.io/reneverland/cbitweb:latest

# 2. 停止并删除旧容器
docker stop cbit-official-web
docker rm cbit-official-web

# 3. 启动新容器
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/reneverland/cbitweb:latest

# 4. 不需要重启Nginx（除非修改了nginx配置）
```

## 📱 监控和日志

### 查看访问日志

```bash
# 实时监控
sudo tail -f /var/log/nginx/cbitweb_access.log

# 查看最近的错误
sudo tail -50 /var/log/nginx/cbitweb_error.log

# 统计访问量
sudo cat /var/log/nginx/cbitweb_access.log | wc -l
```

### 查看Docker容器日志

```bash
# 实时监控
docker logs -f cbit-official-web

# 查看最近100行
docker logs --tail 100 cbit-official-web
```

## 🎯 完整示例配置

参考项目根目录的 `nginx-reverse-proxy.conf` 文件。

## 📞 需要帮助？

如果遇到问题，请提供：
1. Nginx配置文件内容
2. Nginx错误日志：`sudo tail -50 /var/log/nginx/error.log`
3. Docker容器日志：`docker logs --tail 50 cbit-official-web`
4. 浏览器控制台错误（F12 -> Console和Network标签）

---

**作者**: Ren CBIT  
**邮箱**: cooledward@outlook.com  
**GitHub**: https://github.com/reneverland/cbitweb

