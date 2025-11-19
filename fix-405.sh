#!/bin/bash
# 快速修复405 API错误

echo "======================================"
echo "🔧 修复405 API错误"
echo "======================================"
echo ""

# 检查是否以root运行
if [ "$EUID" -ne 0 ]; then 
    echo "❌ 请使用sudo运行此脚本"
    echo "用法: sudo bash fix-405.sh"
    exit 1
fi

# 1. 找到配置文件
echo "1️⃣ 查找Nginx配置文件..."
if [ -f "/www/server/nginx/conf/vhost/cbitweb.conf" ]; then
    CONFIG_PATH="/www/server/nginx/conf/vhost/cbitweb.conf"
    echo "✅ 找到宝塔面板配置: $CONFIG_PATH"
elif [ -f "/etc/nginx/sites-available/cbitweb" ]; then
    CONFIG_PATH="/etc/nginx/sites-available/cbitweb"
    echo "✅ 找到Debian配置: $CONFIG_PATH"
elif [ -f "/etc/nginx/conf.d/cbitweb.conf" ]; then
    CONFIG_PATH="/etc/nginx/conf.d/cbitweb.conf"
    echo "✅ 找到CentOS配置: $CONFIG_PATH"
else
    echo "❌ 未找到配置文件！"
    echo "请先运行: sudo bash setup-nginx.sh"
    exit 1
fi
echo ""

# 2. 备份当前配置
echo "2️⃣ 备份当前配置..."
cp "$CONFIG_PATH" "${CONFIG_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
echo "✅ 备份完成"
echo ""

# 3. 创建新配置
echo "3️⃣ 创建新的Nginx配置..."
cat > /tmp/cbitweb-fix.conf << 'EOF'
# CBIT官网 Nginx反向代理配置
# 修复405 API错误

server {
    listen 80;
    listen [::]:80;
    server_name _;

    # 日志配置
    access_log /var/log/nginx/cbitweb_access.log;
    error_log /var/log/nginx/cbitweb_error.log;

    # API反向代理 - 修复405错误的关键配置
    location /api/ {
        # 处理OPTIONS预检请求（必须在proxy_pass之前）
        if ($request_method = 'OPTIONS') {
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
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
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
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket支持
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # 超时设置
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF

echo "✅ 新配置已创建"
echo ""

# 4. 替换配置文件
echo "4️⃣ 更新配置文件..."
cp /tmp/cbitweb-fix.conf "$CONFIG_PATH"
echo "✅ 配置文件已更新"
echo ""

# 5. 测试配置
echo "5️⃣ 测试Nginx配置..."
if nginx -t; then
    echo "✅ 配置测试通过"
else
    echo "❌ 配置测试失败，恢复备份..."
    cp "${CONFIG_PATH}.backup."* "$CONFIG_PATH" 2>/dev/null || true
    exit 1
fi
echo ""

# 6. 重载Nginx
echo "6️⃣ 重载Nginx..."
if nginx -s reload 2>/dev/null; then
    echo "✅ Nginx已重载"
elif systemctl reload nginx 2>/dev/null; then
    echo "✅ Nginx已重载（systemctl）"
else
    echo "⚠️  请手动重载Nginx: nginx -s reload"
fi
echo ""

# 7. 清理
rm /tmp/cbitweb-fix.conf

# 8. 验证
echo "======================================"
echo "✅ 修复完成！"
echo "======================================"
echo ""
echo "🔍 验证修复:"
echo "   curl -X OPTIONS http://localhost/api/"
echo ""
echo "🌐 测试访问:"
echo "   打开浏览器，尝试使用聊天功能"
echo ""
echo "📋 配置文件位置: $CONFIG_PATH"
echo "📋 备份文件: ${CONFIG_PATH}.backup.*"
echo ""

