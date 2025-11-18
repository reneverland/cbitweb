#!/bin/bash

# CBIT官网快速部署脚本
# 作者：Ren CBIT

set -e

echo "======================================"
echo "  CBIT官网 Docker部署脚本"
echo "======================================"
echo ""

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker未安装，请先安装Docker"
    echo "访问：https://www.docker.com/get-started"
    exit 1
fi

echo "✅ Docker已安装"

# 检查docker-compose是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "⚠️  docker-compose未安装，将使用docker命令"
    USE_COMPOSE=false
else
    echo "✅ docker-compose已安装"
    USE_COMPOSE=true
fi

echo ""
echo "开始构建和部署..."
echo ""

if [ "$USE_COMPOSE" = true ]; then
    # 使用docker-compose
    echo "🐳 使用docker-compose构建和启动服务..."
    docker-compose down 2>/dev/null || true
    docker-compose up -d --build
else
    # 使用docker命令
    echo "🐳 使用docker命令构建和启动服务..."
    
    # 停止并删除旧容器
    docker stop cbit-official-web 2>/dev/null || true
    docker rm cbit-official-web 2>/dev/null || true
    
    # 构建新镜像
    docker build -t cbitweb:latest .
    
    # 运行新容器
    docker run -d \
        -p 3000:80 \
        --name cbit-official-web \
        --restart unless-stopped \
        cbitweb:latest
fi

echo ""
echo "======================================"
echo "✅ 部署完成！"
echo "======================================"
echo ""
echo "📍 访问地址：http://localhost:3000"
echo ""
echo "🔍 查看日志："
echo "   docker logs -f cbit-official-web"
echo ""
echo "🛑 停止服务："
if [ "$USE_COMPOSE" = true ]; then
    echo "   docker-compose down"
else
    echo "   docker stop cbit-official-web"
fi
echo ""
echo "🔄 重启服务："
if [ "$USE_COMPOSE" = true ]; then
    echo "   docker-compose restart"
else
    echo "   docker restart cbit-official-web"
fi
echo ""

