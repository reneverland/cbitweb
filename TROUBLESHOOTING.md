# 部署问题排查指南

## 问题1：图片无法显示

### 原因
图片资源没有被正确复制到构建产物中。

### 解决方案 ✅
已修复：
- ✅ 将 `sources` 目录移动到 `public/sources`
- ✅ Vite构建时会自动复制 `public` 目录下的所有文件
- ✅ 所有 `/sources/xxx.jpg` 路径的引用都能正常工作

### 验证
```bash
# 检查构建产物中是否有sources目录
docker exec cbit-official-web ls -la /usr/share/nginx/html/sources
```

---

## 问题2：容器监听地址配置

### 要求
容器内的Web服务需监听 `0.0.0.0:80`（所有网络接口），而非 `127.0.0.1:80`（仅本地）。

### 解决方案 ✅
已修复：
- ✅ nginx.conf 中配置为 `listen 80;`（默认监听 0.0.0.0）
- ✅ 添加了 `listen [::]:80;` 支持IPv6
- ✅ 添加了访问日志和错误日志

### 验证
```bash
# 进入容器检查nginx配置
docker exec cbit-official-web cat /etc/nginx/conf.d/default.conf | grep listen

# 检查端口监听
docker exec cbit-official-web netstat -tuln | grep :80
```

---

## 问题3：Chat显示"无法连接服务器"

### 可能原因
1. **容器无法访问外部API**（`http://113.106.62.42:9300`）
2. **API服务器网络限制**
3. **CORS跨域问题**
4. **API服务本身的问题**

### 解决方案

#### 方案A：检查容器网络连接 ✅
已添加：
- ✅ DNS配置（8.8.8.8, 8.8.4.4）
- ✅ bridge网络模式
- ✅ 健康检查配置

#### 方案B：测试API连接

```bash
# 1. 进入容器
docker exec -it cbit-official-web sh

# 2. 安装curl（如果没有）
apk add --no-cache curl

# 3. 测试API连接
curl -v http://113.106.62.42:9300

# 4. 测试完整API端点
curl -X POST http://113.106.62.42:9300/api/apps/cbit-official/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer app_WZCqYKovpijz2CO4T5RyiOkuAsP5qlKe" \
  -d '{"messages":[{"role":"user","content":"你好"}],"inputs":{},"response_mode":"blocking","conversation_id":"","user":"web-user","files":[]}'
```

#### 方案C：检查防火墙和网络策略

```bash
# 在宿主机上测试API
curl -v http://113.106.62.42:9300

# 如果宿主机可以访问但容器不行，可能是Docker网络配置问题
# 尝试使用host网络模式
docker run -d --network host --name cbit-web ghcr.io/reneverland/cbitweb:latest
```

#### 方案D：使用host网络模式部署

如果API必须从容器访问，可以使用host网络模式：

```yaml
# docker-compose.yml
services:
  cbitweb:
    network_mode: host
    # 注意：使用host模式时，ports配置会被忽略
```

或使用Docker命令：
```bash
docker run -d --network host --name cbit-official-web ghcr.io/reneverland/cbitweb:latest
```

#### 方案E：API代理（推荐用于生产环境）

如果API服务器有访问限制，可以通过Nginx反向代理：

```nginx
# 在nginx.conf中添加
location /api/ {
    proxy_pass http://113.106.62.42:9300/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # CORS headers
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type' always;
}
```

然后修改 `src/services/api.js`：
```javascript
const API_BASE_URL = '/api'  // 改为相对路径，通过nginx代理
```

---

## 问题4：CORS跨域错误

### 症状
浏览器控制台显示 CORS 相关错误。

### 解决方案 ✅
已添加CORS支持：
- ✅ nginx.conf 中添加了 CORS 头部
- ✅ 支持预检请求（OPTIONS）

---

## 问题5：API密钥安全性

### 当前状态 ⚠️
API密钥直接写在前端代码中（不安全，但方便部署）。

### 生产环境建议
使用后端代理隐藏API密钥：

1. **添加后端服务**（Node.js/Python）
2. **API密钥存储在后端环境变量中**
3. **前端调用后端接口，后端转发到实际API**

示例后端代理（Node.js Express）：
```javascript
app.post('/api/chat', async (req, res) => {
  const response = await axios.post(
    'http://113.106.62.42:9300/api/apps/cbit-official/chat/completions',
    req.body,
    {
      headers: {
        'Authorization': `Bearer ${process.env.API_KEY}`
      }
    }
  )
  res.json(response.data)
})
```

---

## 常用调试命令

```bash
# 查看容器日志
docker logs -f cbit-official-web

# 查看Nginx访问日志
docker exec cbit-official-web tail -f /var/log/nginx/access.log

# 查看Nginx错误日志
docker exec cbit-official-web tail -f /var/log/nginx/error.log

# 进入容器
docker exec -it cbit-official-web sh

# 检查容器健康状态
docker inspect cbit-official-web | grep -A 10 Health

# 检查网络连接
docker exec cbit-official-web ping -c 3 113.106.62.42

# 重启容器
docker restart cbit-official-web

# 完全重新部署
docker-compose down
docker-compose up -d --build
```

---

## 浏览器控制台调试

打开浏览器开发者工具（F12），查看：

1. **Console标签**：查看JavaScript错误和API请求日志
2. **Network标签**：查看API请求详情
   - 检查请求是否发送
   - 查看响应状态码
   - 查看响应内容
3. **Application标签**：查看缓存和存储

---

## 联系支持

如果以上方法都无法解决问题，请提供：

1. 浏览器控制台截图（Console + Network）
2. Docker日志：`docker logs cbit-official-web`
3. Nginx错误日志：`docker exec cbit-official-web cat /var/log/nginx/error.log`
4. 网络测试结果：`docker exec cbit-official-web curl -v http://113.106.62.42:9300`

联系方式：
- GitHub Issues: https://github.com/reneverland/cbitweb/issues
- Email: cooledward@outlook.com

