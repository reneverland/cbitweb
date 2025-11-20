#!/bin/bash
# 验证 Yuqin 是否正确部署

echo "======================================"
echo "🔍 验证 Yuqin 部署状态"
echo "======================================"
echo ""

# 1. 检查容器是否运行
echo "1️⃣ 检查容器状态..."
if docker ps | grep -q cbit-official-web; then
    echo "✅ 容器正在运行"
else
    echo "❌ 容器未运行"
    exit 1
fi
echo ""

# 2. 检查 yuqinprofile.html
echo "2️⃣ 检查 yuqinprofile.html..."
if docker exec cbit-official-web test -f /usr/share/nginx/html/yuqinprofile.html; then
    echo "✅ yuqinprofile.html 存在"
else
    echo "❌ yuqinprofile.html 不存在"
fi
echo ""

# 3. 检查 yuqin.png
echo "3️⃣ 检查 yuqin.png 图片..."
if docker exec cbit-official-web test -f /usr/share/nginx/html/sources/yuqin.png; then
    SIZE=$(docker exec cbit-official-web stat -f%z /usr/share/nginx/html/sources/yuqin.png 2>/dev/null || docker exec cbit-official-web stat -c%s /usr/share/nginx/html/sources/yuqin.png 2>/dev/null)
    echo "✅ yuqin.png 存在 (大小: ${SIZE} bytes)"
else
    echo "❌ yuqin.png 不存在"
fi
echo ""

# 4. 检查 TeamMember.vue 中是否包含 yuqin
echo "4️⃣ 检查团队成员列表..."
if docker exec cbit-official-web sh -c 'grep -r "刁玉钦\|Diao Yuqin\|yuqin" /usr/share/nginx/html/assets/*.js 2>/dev/null | head -1' | grep -q "yuqin"; then
    echo "✅ 团队成员代码包含 yuqin"
else
    echo "❌ 团队成员代码不包含 yuqin（需要重新构建）"
fi
echo ""

# 5. 检查 YuqinProfileApp 组件
echo "5️⃣ 检查 YuqinProfileApp 组件..."
if docker exec cbit-official-web ls /usr/share/nginx/html/assets/ | grep -q "yuqinprofile"; then
    echo "✅ yuqinprofile 组件文件存在"
    docker exec cbit-official-web ls -lh /usr/share/nginx/html/assets/ | grep yuqinprofile
else
    echo "❌ yuqinprofile 组件文件不存在"
fi
echo ""

# 6. 测试访问
echo "6️⃣ 测试页面访问..."
echo "测试主页："
curl -s -I http://localhost:8080/ | head -1
echo "测试 profile.html："
curl -s -I http://localhost:8080/profile.html | head -1
echo "测试 yuqinprofile.html："
curl -s -I http://localhost:8080/yuqinprofile.html | head -1
echo ""

# 7. 检查 Git 版本
echo "7️⃣ 检查代码版本..."
if [ -d "/root/cbitweb" ]; then
    cd /root/cbitweb
    echo "当前 Git 提交："
    git log -1 --oneline
    echo ""
    echo "本地与远程对比："
    git fetch origin
    BEHIND=$(git rev-list --count HEAD..origin/main)
    if [ "$BEHIND" -gt 0 ]; then
        echo "❌ 本地落后远程 $BEHIND 个提交，需要更新"
    else
        echo "✅ 代码是最新的"
    fi
else
    echo "⚠️  未找到项目目录"
fi
echo ""

# 总结
echo "======================================"
echo "📊 总结"
echo "======================================"
echo ""
echo "如果上述检查有❌标记，请运行："
echo "   bash update-production.sh"
echo ""
echo "或手动更新："
echo "   cd /root/cbitweb"
echo "   git pull origin main"
echo "   docker stop cbit-official-web && docker rm cbit-official-web"
echo "   docker build --no-cache -t cbitweb:latest ."
echo "   docker run -d --name cbit-official-web -p 8080:80 --restart unless-stopped cbitweb:latest"
echo ""

