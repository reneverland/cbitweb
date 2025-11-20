#!/bin/bash
# 生产环境完整更新脚本
# 使用方法: 在服务器上运行 bash update-production.sh

set -e

echo "======================================"
echo "🚀 CBIT 官网生产环境完整更新"
echo "======================================"
echo ""

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. 检查环境
echo -e "${BLUE}[1/8]${NC} 检查运行环境..."
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker 未安装${NC}"
    exit 1
fi
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git 未安装${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 环境检查通过${NC}"
echo ""

# 2. 进入项目目录
echo -e "${BLUE}[2/8]${NC} 切换到项目目录..."
if [ ! -d "/root/cbitweb" ]; then
    echo -e "${YELLOW}⚠️  项目目录不存在，正在克隆...${NC}"
    cd /root
    git clone git@github.com:reneverland/cbitweb.git
    cd cbitweb
else
    cd /root/cbitweb
fi
echo -e "${GREEN}✅ 当前目录: $(pwd)${NC}"
echo ""

# 3. 拉取最新代码
echo -e "${BLUE}[3/8]${NC} 拉取最新代码..."
git fetch origin
git reset --hard origin/main
git pull origin main
echo -e "${GREEN}✅ 代码已更新到最新版本${NC}"
echo ""
echo "最新提交:"
git log -1 --oneline
echo ""

# 4. 验证关键文件
echo -e "${BLUE}[4/8]${NC} 验证关键文件..."
MISSING_FILES=()

if [ ! -f "index.html" ]; then
    MISSING_FILES+=("index.html")
fi
if [ ! -f "profile.html" ]; then
    MISSING_FILES+=("profile.html")
fi
if [ ! -f "yuqinprofile.html" ]; then
    MISSING_FILES+=("yuqinprofile.html")
fi
if [ ! -f "shaoyiprofile.html" ]; then
    MISSING_FILES+=("shaoyiprofile.html")
fi
if [ ! -f "vite.config.js" ]; then
    MISSING_FILES+=("vite.config.js")
fi

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo -e "${RED}❌ 缺少关键文件: ${MISSING_FILES[*]}${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 关键文件验证通过${NC}"
echo ""

# 5. 停止并删除旧容器
echo -e "${BLUE}[5/8]${NC} 停止旧容器..."
if docker ps -a | grep -q cbit-official-web; then
    docker stop cbit-official-web 2>/dev/null || true
    docker rm cbit-official-web 2>/dev/null || true
    echo -e "${GREEN}✅ 旧容器已删除${NC}"
else
    echo -e "${YELLOW}⚠️  未发现旧容器${NC}"
fi

# 清理旧镜像
docker rmi cbitweb:latest 2>/dev/null || true
echo ""

# 6. 构建新镜像
echo -e "${BLUE}[6/8]${NC} 构建新 Docker 镜像（约2-3分钟）..."
echo "开始时间: $(date '+%Y-%m-%d %H:%M:%S')"
docker build --no-cache -t cbitweb:latest . 2>&1 | grep -E "Step|SUCCESS|ERROR|yuqin|profile|index.html|DONE" || true
echo -e "${GREEN}✅ 镜像构建完成${NC}"
echo ""

# 7. 启动新容器
echo -e "${BLUE}[7/8]${NC} 启动新容器..."
docker run -d \
  --name cbit-official-web \
  -p 8080:80 \
  --restart unless-stopped \
  cbitweb:latest

echo "等待容器启动..."
sleep 5

if docker ps | grep -q cbit-official-web; then
    echo -e "${GREEN}✅ 容器启动成功${NC}"
else
    echo -e "${RED}❌ 容器启动失败${NC}"
    docker logs cbit-official-web
    exit 1
fi
echo ""

# 8. 验证部署
echo -e "${BLUE}[8/8]${NC} 验证部署结果..."
echo ""

echo "📋 容器状态:"
docker ps | grep cbit-official-web
echo ""

echo "📄 HTML 文件列表:"
docker exec cbit-official-web ls -lh /usr/share/nginx/html/*.html
echo ""

echo "📦 Assets 文件:"
docker exec cbit-official-web ls -lh /usr/share/nginx/html/assets/*.js | head -5
echo ""

echo "🔍 关键文件检查:"
CHECKS=0
PASSED=0

# 检查 index.html
CHECKS=$((CHECKS+1))
if docker exec cbit-official-web test -f /usr/share/nginx/html/index.html; then
    echo -e "${GREEN}✅ index.html${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ index.html${NC}"
fi

# 检查 profile.html
CHECKS=$((CHECKS+1))
if docker exec cbit-official-web test -f /usr/share/nginx/html/profile.html; then
    echo -e "${GREEN}✅ profile.html${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ profile.html${NC}"
fi

# 检查 yuqinprofile.html
CHECKS=$((CHECKS+1))
if docker exec cbit-official-web test -f /usr/share/nginx/html/yuqinprofile.html; then
    echo -e "${GREEN}✅ yuqinprofile.html${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ yuqinprofile.html${NC}"
fi

# 检查 shaoyiprofile.html
CHECKS=$((CHECKS+1))
if docker exec cbit-official-web test -f /usr/share/nginx/html/shaoyiprofile.html; then
    echo -e "${GREEN}✅ shaoyiprofile.html${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ shaoyiprofile.html${NC}"
fi

# 检查 sources 目录
CHECKS=$((CHECKS+1))
if docker exec cbit-official-web test -d /usr/share/nginx/html/sources; then
    echo -e "${GREEN}✅ sources/ 目录${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ sources/ 目录${NC}"
fi

# 检查 yuqin.png
CHECKS=$((CHECKS+1))
if docker exec cbit-official-web test -f /usr/share/nginx/html/sources/yuqin.png; then
    echo -e "${GREEN}✅ sources/yuqin.png${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ sources/yuqin.png${NC}"
fi

# 检查 shaoyi.jpg
CHECKS=$((CHECKS+1))
if docker exec cbit-official-web test -f /usr/share/nginx/html/sources/shaoyi.jpg; then
    echo -e "${GREEN}✅ sources/shaoyi.jpg${NC}"
    PASSED=$((PASSED+1))
else
    echo -e "${RED}❌ sources/shaoyi.jpg${NC}"
fi

echo ""
echo "检查结果: $PASSED/$CHECKS 通过"
echo ""

# 检查 API 路径问题
echo "🔍 检查 API 路径配置:"
if docker exec cbit-official-web sh -c 'grep -r "/api/api" /usr/share/nginx/html/assets/*.js 2>/dev/null'; then
    echo -e "${RED}❌ 发现重复的 /api/api 路径${NC}"
else
    echo -e "${GREEN}✅ 没有重复的 API 路径${NC}"
fi
echo ""

# 最终报告
echo "======================================"
if [ $PASSED -eq $CHECKS ]; then
    echo -e "${GREEN}✅ 部署成功！所有检查通过${NC}"
else
    echo -e "${YELLOW}⚠️  部署完成，但有 $((CHECKS-PASSED)) 项检查未通过${NC}"
fi
echo "======================================"
echo ""

# 访问信息
echo "🌐 访问地址:"
SERVER_IP=$(hostname -I | awk '{print $1}')
echo "   主页: https://cbit.cuhk.edu.cn"
echo "   石仁达: https://cbit.cuhk.edu.cn/profile.html"
echo "   刁玉钦: https://cbit.cuhk.edu.cn/yuqinprofile.html"
echo "   龚少一: https://cbit.cuhk.edu.cn/shaoyiprofile.html"
echo ""
echo "   或通过 IP 访问:"
echo "   http://$SERVER_IP:8080"
echo "   http://$SERVER_IP:8080/profile.html"
echo "   http://$SERVER_IP:8080/yuqinprofile.html"
echo "   http://$SERVER_IP:8080/shaoyiprofile.html"
echo ""

# 下一步建议
echo "📝 下一步:"
echo "   1. 在浏览器中清除缓存 (Ctrl+Shift+R)"
echo "   2. 访问上述地址验证功能"
echo "   3. 测试聊天功能是否正常"
echo "   4. 查看日志: docker logs -f cbit-official-web"
echo ""

echo "完成时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

