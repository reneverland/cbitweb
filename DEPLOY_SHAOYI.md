# 龚少一个人页面部署指南

## 📦 已更新的文件

- ✅ `shaoyiprofile.html` - 龚少一个人页面入口
- ✅ `src/ShaoyiProfileApp.vue` - Vue组件
- ✅ `src/shaoyi-profile-main.js` - JS入口
- ✅ `src/components/TeamMember.vue` - 团队成员列表（已添加龚少一）
- ✅ `vite.config.js` - 多页面配置（已添加新页面）
- ✅ `update-production.sh` - 部署脚本（已更新检查项）
- ✅ `public/sources/shaoyi.jpg` - 个人照片

## 🚀 服务器部署步骤

### 方式一：一键部署（推荐）

在服务器上运行：

```bash
# 1. 进入项目目录
cd /root/cbitweb

# 2. 执行部署脚本（约3-5分钟）
bash update-production.sh
```

脚本会自动完成：
- ✅ 拉取最新代码
- ✅ 验证所有文件（包括shaoyiprofile.html）
- ✅ 停止旧容器
- ✅ 构建新Docker镜像
- ✅ 启动新容器
- ✅ 验证部署结果

### 方式二：手动部署

```bash
# 1. 进入项目目录
cd /root/cbitweb

# 2. 拉取最新代码
git pull origin main

# 3. 验证新文件
ls -lh shaoyiprofile.html
ls -lh public/sources/shaoyi.jpg

# 4. 停止旧容器
docker stop cbit-official-web
docker rm cbit-official-web

# 5. 构建新镜像
docker build --no-cache -t cbitweb:latest .

# 6. 启动新容器
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  cbitweb:latest

# 7. 验证部署
docker exec cbit-official-web ls -lh /usr/share/nginx/html/shaoyiprofile.html
docker exec cbit-official-web ls -lh /usr/share/nginx/html/sources/shaoyi.jpg
```

## 🔍 验证部署

### 1. 检查容器状态
```bash
docker ps | grep cbit-official-web
```

### 2. 检查文件是否存在
```bash
# 检查HTML页面
docker exec cbit-official-web test -f /usr/share/nginx/html/shaoyiprofile.html && echo "✅ HTML存在" || echo "❌ HTML缺失"

# 检查照片
docker exec cbit-official-web test -f /usr/share/nginx/html/sources/shaoyi.jpg && echo "✅ 照片存在" || echo "❌ 照片缺失"
```

### 3. 访问网页测试

在浏览器中访问以下地址：

- **主页团队列表**：https://cbit.cuhk.edu.cn
  - 在团队成员部分应该能看到龚少一的卡片
  
- **龚少一个人页面**：https://cbit.cuhk.edu.cn/shaoyiprofile.html
  - 应该能看到完整的个人资料页面
  - 包含教育背景、工作经历、研究兴趣等

- **本地测试**（如果服务器IP是`xxx.xxx.xxx.xxx`）：
  - http://xxx.xxx.xxx.xxx:8080/shaoyiprofile.html

## 🐛 故障排查

### 问题1：页面404
```bash
# 检查文件是否被正确构建
docker exec cbit-official-web ls -lh /usr/share/nginx/html/*.html

# 如果缺失，重新构建
docker stop cbit-official-web && docker rm cbit-official-web
docker build --no-cache -t cbitweb:latest .
docker run -d --name cbit-official-web -p 8080:80 --restart unless-stopped cbitweb:latest
```

### 问题2：照片无法显示
```bash
# 检查sources目录
docker exec cbit-official-web ls -lh /usr/share/nginx/html/sources/

# 检查shaoyi.jpg
docker exec cbit-official-web ls -lh /usr/share/nginx/html/sources/shaoyi.jpg
```

### 问题3：需要查看日志
```bash
# 查看容器日志
docker logs -f cbit-official-web

# 查看Nginx错误日志
docker exec cbit-official-web cat /var/log/nginx/error.log
```

## 📱 测试清单

部署后请验证以下功能：

- [ ] 主页可以正常访问
- [ ] 团队成员列表显示龚少一
- [ ] 点击龚少一的卡片可以跳转到个人页面
- [ ] 个人页面可以正常访问：https://cbit.cuhk.edu.cn/shaoyiprofile.html
- [ ] 个人页面显示正确的信息：
  - [ ] 姓名：龚少一 (Gong Shaoyi)
  - [ ] 职位：研究助理
  - [ ] 邮箱：12518440@zju.edu.cn
  - [ ] 教育背景：浙江大学（博士）、中山大学（本科）
  - [ ] 研究领域：AI、医学AI、智能医疗
- [ ] 照片正常显示
- [ ] 返回主页按钮工作正常
- [ ] 响应式设计在移动端正常

## 🎉 完成

部署完成后，团队成员可以通过以下方式访问龚少一的个人页面：

1. 从主页团队成员列表点击进入
2. 直接访问 https://cbit.cuhk.edu.cn/shaoyiprofile.html
3. 从邮箱签名或名片分享链接

---

**作者**: Ren Shi  
**更新时间**: 2024-11-20  
**相关文件**: SERVER_DEPLOYMENT.md, update-production.sh

