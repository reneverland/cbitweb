# 快速修复指南

## 问题1：Nginx配置目录不存在

### 错误信息
```
cp: cannot create regular file '/etc/nginx/conf.d/cbitweb.conf': No such file or directory
```

### 解决方案

#### 选项A：创建目录（推荐）

```bash
# 创建conf.d目录
sudo mkdir -p /etc/nginx/conf.d

# 然后重新运行部署脚本
sudo bash setup-nginx.sh 10.20.217.43
```

#### 选项B：手动配置

```bash
# 1. 创建配置目录（根据您的nginx版本选择）
sudo mkdir -p /etc/nginx/sites-available
sudo mkdir -p /etc/nginx/sites-enabled

# 或者
sudo mkdir -p /etc/nginx/conf.d

# 2. 手动复制配置文件
# 如果使用sites-available目录：
sudo cp nginx-reverse-proxy.conf /etc/nginx/sites-available/cbitweb
sudo ln -s /etc/nginx/sites-available/cbitweb /etc/nginx/sites-enabled/

# 或者使用conf.d目录：
sudo cp nginx-reverse-proxy.conf /etc/nginx/conf.d/cbitweb.conf

# 3. 编辑配置文件，修改server_name为您的IP
sudo nano /etc/nginx/sites-available/cbitweb
# 或
sudo nano /etc/nginx/conf.d/cbitweb.conf

# 4. 测试并重启
sudo nginx -t
sudo systemctl reload nginx
```

#### 选项C：检查nginx主配置

```bash
# 查看nginx主配置文件
sudo cat /etc/nginx/nginx.conf | grep include

# 找到include指令，例如：
# include /etc/nginx/conf.d/*.conf;
# include /etc/nginx/sites-enabled/*;

# 根据实际的include路径放置配置文件
```

---

## 问题2：profile.html链接跳转问题

### 症状
点击石仁达的链接跳转到 `https://cbit.cuhk.edu.cn/profile.html` 而不是本地

### 原因分析

这是**正常行为**！原因：
1. 链接使用的是相对路径 `/profile.html`
2. 如果您在 `http://10.20.217.43` 访问，会跳转到 `http://10.20.217.43/profile.html` ✅
3. 如果您在 `https://cbit.cuhk.edu.cn` 访问，会跳转到 `https://cbit.cuhk.edu.cn/profile.html` ✅

### 解决方案

#### 步骤1：确保最新代码已构建

```bash
# 在服务器上拉取最新镜像（包含profile.html支持）
docker pull ghcr.io/reneverland/cbitweb:latest

# 停止旧容器
docker stop cbit-official-web
docker rm cbit-official-web

# 启动新容器
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/reneverland/cbitweb:latest
```

#### 步骤2：验证profile.html存在

```bash
# 检查容器中是否有profile.html
docker exec cbit-official-web ls -la /usr/share/nginx/html/ | grep -E "(index|profile)"

# 应该看到：
# index.html
# profile.html

# 直接访问测试
curl http://10.20.217.43/profile.html

# 应该返回HTML内容，不是404
```

#### 步骤3：通过Nginx访问

```bash
# 如果配置了Nginx反向代理，通过主域名访问：
curl http://10.20.217.43/profile.html

# 在浏览器中访问：
# http://10.20.217.43/profile.html
```

### 如果profile.html仍然不存在

说明Docker镜像可能还没有包含最新的多页面配置。等待GitHub Actions完成构建（约3-5分钟），然后重新拉取镜像。

或者本地构建：

```bash
# 克隆代码
git clone https://github.com/reneverland/cbitweb.git
cd cbitweb

# 本地构建镜像
docker build -t cbitweb:local .

# 运行本地镜像
docker stop cbit-official-web
docker rm cbit-official-web
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  cbitweb:local
```

---

## 完整验证清单

### ✅ 检查Docker容器

```bash
# 容器运行状态
docker ps | grep cbit
# 应该看到：cbit-official-web ... Up ... 0.0.0.0:8080->80/tcp

# 容器日志（无错误）
docker logs --tail 50 cbit-official-web

# 直接访问容器
curl http://127.0.0.1:8080
curl http://127.0.0.1:8080/profile.html
```

### ✅ 检查Nginx配置

```bash
# Nginx配置测试
sudo nginx -t
# 应该显示：nginx: configuration file /etc/nginx/nginx.conf test is successful

# Nginx运行状态
sudo systemctl status nginx
# 应该显示：active (running)

# 通过Nginx访问
curl http://10.20.217.43/
curl http://10.20.217.43/profile.html
```

### ✅ 检查API代理

```bash
# 测试API代理（应该返回错误，但不是CORS错误）
curl -X POST http://10.20.217.43/api/api/apps/cbit-official/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"test"}]}'

# 不应该看到CORS相关的错误
```

### ✅ 浏览器测试

1. 打开浏览器访问：`http://10.20.217.43`
2. 打开开发者工具（F12）
3. 点击石仁达的链接
4. 检查：
   - URL应该变为：`http://10.20.217.43/profile.html`
   - 页面应该显示石仁达的个人主页
   - Console中无错误

---

## 常见问题

### Q1: GitHub Actions构建失败

查看构建日志：https://github.com/reneverland/cbitweb/actions

常见原因：
- npm install失败：清理缓存重试
- vite build失败：检查vite.config.js语法

### Q2: Docker镜像拉取失败

```bash
# 检查网络
ping ghcr.io

# 手动登录（如果需要）
echo YOUR_GITHUB_TOKEN | docker login ghcr.io -u reneverland --password-stdin

# 强制重新拉取
docker pull --no-cache ghcr.io/reneverland/cbitweb:latest
```

### Q3: Nginx配置生效但访问仍有问题

```bash
# 完全重启nginx
sudo systemctl restart nginx

# 清除浏览器缓存
# Chrome: Ctrl+Shift+Delete -> 清除缓存

# 检查防火墙
sudo firewall-cmd --list-all  # CentOS
sudo ufw status               # Ubuntu
```

---

## 需要帮助？

提供以下信息以便排查：

1. **系统信息**
```bash
cat /etc/os-release
nginx -v
docker --version
```

2. **服务状态**
```bash
docker ps -a | grep cbit
sudo systemctl status nginx
```

3. **日志**
```bash
# Nginx日志
sudo tail -50 /var/log/nginx/error.log

# Docker日志
docker logs --tail 50 cbit-official-web

# Nginx配置
cat /etc/nginx/sites-available/cbitweb
# 或
cat /etc/nginx/conf.d/cbitweb.conf
```

4. **浏览器信息**
- F12 -> Console标签（截图）
- F12 -> Network标签（截图）
- 当前URL

---

**联系方式**：
- GitHub Issues: https://github.com/reneverland/cbitweb/issues
- Email: cooledward@outlook.com

