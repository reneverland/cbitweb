# 服务器更新指南

## 🚀 一键更新（推荐）

### 在服务器上运行

```bash
# SSH 登录到服务器
ssh your-server

# 方式1：如果项目已存在
cd /root/cbitweb
git pull origin main
bash update-production.sh

# 方式2：全新部署
wget https://raw.githubusercontent.com/reneverland/cbitweb/main/update-production.sh
bash update-production.sh
```

---

## 📋 脚本功能

`update-production.sh` 会自动完成以下操作：

### ✅ 自动化步骤

1. **环境检查** - 验证 Docker 和 Git 是否安装
2. **代码更新** - 拉取最新的代码
3. **文件验证** - 确认所有关键文件存在
   - ✅ index.html
   - ✅ profile.html (石仁达)
   - ✅ yuqinprofile.html (刁玉钦)
4. **容器管理** - 停止并删除旧容器
5. **镜像构建** - 无缓存构建新镜像
6. **启动服务** - 运行新容器
7. **部署验证** - 检查所有文件是否正确部署
8. **路径检查** - 验证 API 路径配置

### ✅ 验证项目

脚本会自动检查：

- ✅ 三个 HTML 页面都存在
- ✅ sources 目录完整
- ✅ yuqin.png 图片存在
- ✅ 没有重复的 /api/api 路径
- ✅ 容器正常运行

---

## 🔍 手动验证

### 检查容器状态

```bash
# 查看容器运行状态
docker ps | grep cbit-official-web

# 查看容器日志
docker logs -f cbit-official-web

# 查看容器内文件
docker exec cbit-official-web ls -la /usr/share/nginx/html/
```

### 检查页面文件

```bash
# 检查所有 HTML 文件
docker exec cbit-official-web ls -lh /usr/share/nginx/html/*.html

# 应该看到：
# index.html
# profile.html
# yuqinprofile.html
```

### 测试访问

```bash
# 测试 Docker 容器直接访问
curl -I http://localhost:8080
curl -I http://localhost:8080/profile.html
curl -I http://localhost:8080/yuqinprofile.html

# 测试通过 Nginx 代理访问
curl -I http://localhost
curl -I http://localhost/profile.html
curl -I http://localhost/yuqinprofile.html
```

---

## 🌐 访问地址

### 生产环境

- **主页**: https://cbit.cuhk.edu.cn
- **石仁达**: https://cbit.cuhk.edu.cn/profile.html
- **刁玉钦**: https://cbit.cuhk.edu.cn/yuqinprofile.html

### 直接访问 Docker (调试用)

- http://your-server-ip:8080
- http://your-server-ip:8080/profile.html
- http://your-server-ip:8080/yuqinprofile.html

---

## 🐛 常见问题

### 1. 页面显示 404

**原因**: 文件未正确部署

**解决方案**:
```bash
# 检查文件是否存在
docker exec cbit-official-web ls -la /usr/share/nginx/html/*.html

# 如果缺少文件，重新构建
bash update-production.sh
```

### 2. API 调用 404

**原因**: API 路径重复 (/api/api/...)

**解决方案**:
```bash
# 检查是否有重复路径
docker exec cbit-official-web grep -r "/api/api" /usr/share/nginx/html/assets/*.js

# 如果有，重新构建
bash update-production.sh
```

### 3. 图片显示不出来

**原因**: sources 目录未复制

**解决方案**:
```bash
# 检查 sources 目录
docker exec cbit-official-web ls -la /usr/share/nginx/html/sources/

# 检查 yuqin.png
docker exec cbit-official-web test -f /usr/share/nginx/html/sources/yuqin.png && echo "存在" || echo "不存在"
```

### 4. 浏览器缓存问题

**解决方案**:
- 强制刷新: `Ctrl + Shift + R`
- 清除缓存: `Ctrl + Shift + Delete`
- 使用无痕模式: `Ctrl + Shift + N`

---

## 📊 更新记录

### 检查当前版本

```bash
cd /root/cbitweb
git log -1 --oneline
```

### 查看更新日志

```bash
git log --oneline -10
```

---

## ⚡ 快速命令参考

```bash
# 完整更新
bash update-production.sh

# 查看容器状态
docker ps | grep cbit

# 重启容器（不重新构建）
docker restart cbit-official-web

# 查看日志
docker logs -f cbit-official-web

# 停止服务
docker stop cbit-official-web

# 清理资源
docker system prune -a
```

---

## 🔐 权限要求

- **Root 权限** 或 **sudo 权限**
- **Docker 权限** - 能够执行 docker 命令
- **Git 权限** - 能够 git pull

---

## 📞 支持

如遇到问题：

1. 查看脚本输出的错误信息
2. 检查 Docker 日志
3. 联系管理员

---

## ✅ 成功标志

更新成功后，你应该看到：

```
====================================
✅ 部署成功！所有检查通过
====================================

🌐 访问地址:
   主页: https://cbit.cuhk.edu.cn
   Ren 达: https://cbit.cuhk.edu.cn/profile.html
   刁玉钦: https://cbit.cuhk.edu.cn/yuqinprofile.html
```

---

**更新时间**: 2024-11-20  
**脚本版本**: v1.0.0  
**维护者**: Ren CBIT

