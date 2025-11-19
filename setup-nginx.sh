#!/bin/bash

# CBIT官网 Nginx反向代理快速配置脚本
# 用法: sudo bash setup-nginx.sh [您的IP或域名]
# 例如: sudo bash setup-nginx.sh 10.20.217.43

set -e

echo "=========================================="
echo "  CBIT官网 Nginx反向代理配置工具"
echo "=========================================="
echo ""

# 检查是否以root运行
if [ "$EUID" -ne 0 ]; then 
    echo "❌ 请使用sudo运行此脚本"
    echo "用法: sudo bash setup-nginx.sh [您的IP或域名]"
    exit 1
fi

# 获取IP或域名
SERVER_NAME=${1:-"10.20.217.43"}
echo "✅ 服务器地址: $SERVER_NAME"
echo ""

# 检测系统类型
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "❌ 无法检测系统类型"
    exit 1
fi

echo "✅ 检测到系统: $OS"
echo ""

# 检查Nginx是否安装
if ! command -v nginx &> /dev/null; then
    echo "❌ Nginx未安装"
    echo "请先安装Nginx："
    if [ "$OS" = "ubuntu" ] || [ "$OS" = "debian" ]; then
        echo "  sudo apt-get update"
        echo "  sudo apt-get install nginx"
    elif [ "$OS" = "centos" ] || [ "$OS" = "rhel" ]; then
        echo "  sudo yum install nginx"
    fi
    exit 1
fi

echo "✅ Nginx已安装"
echo ""

# 检查Docker容器是否运行
if ! docker ps | grep -q cbit-official-web; then
    echo "⚠️  Docker容器未运行，正在启动..."
    docker run -d \
        --name cbit-official-web \
        -p 8080:80 \
        --restart unless-stopped \
        ghcr.io/reneverland/cbitweb:latest || {
        echo "❌ 启动Docker容器失败"
        exit 1
    }
    echo "✅ Docker容器已启动"
else
    echo "✅ Docker容器正在运行"
fi
echo ""

# 创建Nginx配置
echo "📝 创建Nginx配置文件..."

NGINX_CONF="/tmp/cbitweb-nginx.conf"

cat > $NGINX_CONF << EOF
# CBIT官网 Nginx反向代理配置
# 自动生成于 $(date)

server {
    listen 80;
    server_name $SERVER_NAME;

    # 日志配置
    access_log /var/log/nginx/cbitweb_access.log;
    error_log /var/log/nginx/cbitweb_error.log;

    # API反向代理 - 解决CORS问题
    location /api/ {
        # 处理OPTIONS预检请求（必须在proxy_pass之前）
        if (\$request_method = 'OPTIONS') {
            add_header 'Access-Control-Allow-Origin' '*' always;
            add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
            add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization' always;
            add_header 'Access-Control-Max-Age' 1728000 always;
            add_header 'Content-Type' 'text/plain; charset=utf-8' always;
            add_header 'Content-Length' 0 always;
            return 204;
        }
        
        # 代理到外部API服务器
        proxy_pass http://113.106.62.42:9300/;
        
        # 请求头设置
        proxy_set_header Host 113.106.62.42;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # CORS headers（为实际请求添加）
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization' always;
        add_header 'Access-Control-Allow-Credentials' 'true' always;
        add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range' always;
        
        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # 错误处理
        proxy_intercept_errors off;
    }

    # 代理到Docker容器
    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # WebSocket支持
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF

# 检测Nginx安装类型并复制配置文件
if [ -d "/www/server/nginx/conf/vhost" ]; then
    # 宝塔面板 (BT Panel)
    echo "✅ 检测到宝塔面板安装的Nginx"
    DEST_PATH="/www/server/nginx/conf/vhost/cbitweb.conf"
    cp $NGINX_CONF $DEST_PATH
    echo "✅ 配置文件已安装: $DEST_PATH"
    NGINX_TYPE="bt"
    
elif [ -d "/etc/nginx/sites-available" ]; then
    # Ubuntu/Debian style
    DEST_PATH="/etc/nginx/sites-available/cbitweb"
    LINK_PATH="/etc/nginx/sites-enabled/cbitweb"
    
    cp $NGINX_CONF $DEST_PATH
    
    # 删除旧的符号链接（如果存在）
    if [ -L $LINK_PATH ]; then
        rm $LINK_PATH
    fi
    
    # 创建符号链接
    ln -s $DEST_PATH $LINK_PATH
    
    echo "✅ 配置文件已安装: $DEST_PATH"
    echo "✅ 符号链接已创建: $LINK_PATH"
    NGINX_TYPE="debian"
    
elif [ -d "/etc/nginx/conf.d" ]; then
    # CentOS/RHEL style
    DEST_PATH="/etc/nginx/conf.d/cbitweb.conf"
    cp $NGINX_CONF $DEST_PATH
    echo "✅ 配置文件已安装: $DEST_PATH"
    NGINX_TYPE="centos"
    
else
    # 创建conf.d目录（如果不存在）
    echo "⚠️  标准nginx配置目录不存在，创建 /etc/nginx/conf.d/"
    mkdir -p /etc/nginx/conf.d
    DEST_PATH="/etc/nginx/conf.d/cbitweb.conf"
    cp $NGINX_CONF $DEST_PATH
    echo "✅ 配置文件已安装: $DEST_PATH"
    NGINX_TYPE="generic"
fi

echo ""

# 测试Nginx配置
echo "🔍 测试Nginx配置..."
if nginx -t; then
    echo "✅ Nginx配置测试通过"
else
    echo "❌ Nginx配置测试失败"
    echo "请检查上面的错误信息"
    exit 1
fi

echo ""

# 重启Nginx（根据安装类型使用不同的方法）
echo "🔄 重启Nginx..."

if [ "$NGINX_TYPE" = "bt" ]; then
    # 宝塔面板：使用nginx -s reload
    echo "使用宝塔面板重启方式..."
    if nginx -s reload 2>/dev/null; then
        echo "✅ Nginx已重启（nginx -s reload）"
    elif [ -f "/etc/init.d/nginx" ]; then
        /etc/init.d/nginx reload
        echo "✅ Nginx已重启（init.d）"
    else
        # 如果以上方法都失败，尝试直接kill并重启
        echo "⚠️  尝试直接重启nginx进程..."
        pkill -HUP nginx || true
        echo "✅ Nginx已重载"
    fi
else
    # 标准系统：使用systemctl
    if systemctl reload nginx 2>/dev/null; then
        echo "✅ Nginx已重启（systemctl reload）"
    elif systemctl restart nginx 2>/dev/null; then
        echo "✅ Nginx已重启（systemctl restart）"
    elif service nginx reload 2>/dev/null; then
        echo "✅ Nginx已重启（service reload）"
    elif nginx -s reload 2>/dev/null; then
        echo "✅ Nginx已重启（nginx -s reload）"
    else
        echo "⚠️  无法自动重启Nginx，请手动重启"
        echo "   宝塔面板: 在面板中重启Nginx"
        echo "   命令行: nginx -s reload"
    fi
fi
echo ""

# 验证服务
echo "=========================================="
echo "  ✅ 配置完成！"
echo "=========================================="
echo ""
echo "📍 访问地址："
echo "   http://$SERVER_NAME"
echo ""
echo "🔍 验证服务："
echo "   主页: curl http://$SERVER_NAME/"
echo "   API: curl http://$SERVER_NAME/api/api/apps/cbit-official/chat/completions"
echo ""
echo "📊 查看日志："
echo "   访问日志: sudo tail -f /var/log/nginx/cbitweb_access.log"
echo "   错误日志: sudo tail -f /var/log/nginx/cbitweb_error.log"
echo "   容器日志: docker logs -f cbit-official-web"
echo ""
echo "🔧 管理命令："
if [ "$NGINX_TYPE" = "bt" ]; then
    echo "   重启Nginx: nginx -s reload （或在宝塔面板中重启）"
    echo "   配置文件: /www/server/nginx/conf/vhost/cbitweb.conf"
else
    echo "   重启Nginx: sudo systemctl reload nginx"
    echo "   配置文件: $DEST_PATH"
fi
echo "   重启容器: docker restart cbit-official-web"
echo "   查看状态: docker ps | grep cbit"
echo ""

# 清理临时文件
rm $NGINX_CONF

echo "🎉 部署成功！请在浏览器中访问 http://$SERVER_NAME"
echo ""

