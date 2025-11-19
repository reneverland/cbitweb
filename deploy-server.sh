#!/bin/bash
# CBIT官网服务器部署脚本
# 使用方法: bash deploy-server.sh

set -e  # 遇到错误立即退出

echo "================================"
echo "🚀 CBIT官网自动部署脚本"
echo "================================"
echo ""

# 检查是否在项目根目录
if [ ! -f "setup-nginx.sh" ]; then
    echo "❌ 错误: 请在项目根目录运行此脚本"
    echo "   当前目录: $(pwd)"
    echo "   应该运行: cd /path/to/cbitweb && bash deploy-server.sh"
    exit 1
fi

# 1. 更新代码
echo "📥 [1/5] 拉取最新代码..."
git pull origin main
echo "✅ 代码更新完成"
echo ""

# 2. 配置Nginx
echo "⚙️  [2/5] 配置Nginx反向代理..."
sudo bash setup-nginx.sh
echo ""

# 3. 停止旧容器
echo "🛑 [3/5] 停止旧容器..."
if docker ps -a | grep -q cbit-official-web; then
    docker stop cbit-official-web 2>/dev/null || true
    docker rm cbit-official-web 2>/dev/null || true
    echo "✅ 旧容器已停止并移除"
else
    echo "ℹ️  没有发现旧容器"
fi
echo ""

# 4. 拉取新镜像
echo "📦 [4/5] 拉取最新Docker镜像..."
docker pull ghcr.io/reneverland/cbitweb:latest
echo "✅ 镜像拉取完成"
echo ""

# 5. 启动新容器
echo "🐳 [5/5] 启动Docker容器..."
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  ghcr.io/reneverland/cbitweb:latest

echo "✅ 容器启动完成"
echo ""

# 6. 等待服务启动
echo "⏳ 等待服务启动..."
sleep 5

# 7. 验证部署
echo "================================"
echo "🔍 验证部署状态"
echo "================================"
echo ""

echo "📊 Docker容器状态:"
docker ps | grep cbit-official-web || echo "❌ 容器未运行"
echo ""

echo "📊 Nginx状态:"
sudo systemctl status nginx --no-pager | head -n 5
echo ""

echo "🌐 测试Docker容器访问:"
if curl -s -I http://localhost:8080 | head -n 1; then
    echo "✅ Docker容器访问正常"
else
    echo "❌ Docker容器访问失败"
fi
echo ""

echo "🌐 测试Nginx代理访问:"
if curl -s -I http://localhost | head -n 1; then
    echo "✅ Nginx代理访问正常"
else
    echo "❌ Nginx代理访问失败"
fi
echo ""

# 8. 显示日志
echo "📋 最近的容器日志:"
docker logs --tail 20 cbit-official-web
echo ""

echo "================================"
echo "🎉 部署完成！"
echo "================================"
echo ""
echo "访问方式:"
echo "  - 直接访问Docker: http://$(hostname -I | awk '{print $1}'):8080"
echo "  - 通过Nginx代理:  http://$(hostname -I | awk '{print $1}')"
echo ""
echo "查看日志: docker logs -f cbit-official-web"
echo "重启容器: docker restart cbit-official-web"
echo "================================"

