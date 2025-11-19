#!/bin/bash
# CBIT官网诊断脚本
echo "======================================"
echo "🔍 CBIT官网部署诊断"
echo "======================================"
echo ""

echo "1️⃣ 检查Nginx配置文件位置"
echo "--------------------------------------"
if [ -f "/www/server/nginx/conf/vhost/cbitweb.conf" ]; then
    echo "✅ 宝塔面板配置文件存在"
    CONFIG_PATH="/www/server/nginx/conf/vhost/cbitweb.conf"
elif [ -f "/etc/nginx/sites-available/cbitweb" ]; then
    echo "✅ Debian/Ubuntu配置文件存在"
    CONFIG_PATH="/etc/nginx/sites-available/cbitweb"
elif [ -f "/etc/nginx/conf.d/cbitweb.conf" ]; then
    echo "✅ CentOS/RHEL配置文件存在"
    CONFIG_PATH="/etc/nginx/conf.d/cbitweb.conf"
else
    echo "❌ 未找到配置文件！需要运行: sudo bash setup-nginx.sh"
    CONFIG_PATH=""
fi
echo ""

if [ -n "$CONFIG_PATH" ]; then
    echo "2️⃣ 检查API代理配置"
    echo "--------------------------------------"
    if grep -q "location /api/" "$CONFIG_PATH"; then
        echo "✅ 找到API代理配置"
        echo ""
        echo "API代理配置内容:"
        grep -A 30 "location /api/" "$CONFIG_PATH" | head -35
    else
        echo "❌ 未找到API代理配置！"
        echo "需要重新运行: sudo bash setup-nginx.sh"
    fi
    echo ""
    
    echo "3️⃣ 检查OPTIONS处理"
    echo "--------------------------------------"
    if grep -q "if (\$request_method = 'OPTIONS')" "$CONFIG_PATH"; then
        echo "✅ 找到OPTIONS预检处理"
    else
        echo "❌ 未找到OPTIONS预检处理（这是405错误的原因）"
        echo "需要更新配置: sudo bash setup-nginx.sh"
    fi
    echo ""
fi

echo "4️⃣ 检查Docker容器"
echo "--------------------------------------"
if docker ps | grep -q cbit-official-web; then
    echo "✅ Docker容器正在运行"
    docker ps | grep cbit-official-web
else
    echo "❌ Docker容器未运行"
fi
echo ""

echo "5️⃣ 测试端口访问"
echo "--------------------------------------"
echo "测试Docker容器 (8080):"
curl -s -I http://localhost:8080 | head -3 || echo "❌ 无法访问"
echo ""
echo "测试Nginx代理 (80):"
curl -s -I http://localhost | head -3 || echo "❌ 无法访问"
echo ""
echo "测试API代理:"
curl -s -I http://localhost/api/ | head -3 || echo "❌ 无法访问"
echo ""

echo "6️⃣ 检查Nginx进程"
echo "--------------------------------------"
ps aux | grep nginx | grep -v grep || echo "❌ Nginx未运行"
echo ""

echo "======================================"
echo "📋 诊断完成"
echo "======================================"
echo ""
echo "💡 修复建议:"
echo "   1. 如果配置文件不存在或内容错误："
echo "      cd /path/to/cbitweb"
echo "      git pull origin main"
echo "      sudo bash setup-nginx.sh"
echo ""
echo "   2. 如果配置文件正确但未生效："
echo "      nginx -t              # 测试配置"
echo "      nginx -s reload       # 重载配置"
echo ""
echo "   3. 如果Docker容器未运行："
echo "      bash deploy-server.sh"
echo ""

