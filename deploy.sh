#!/bin/bash

echo "🚀 开始自动部署表情包生成器..."

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误：请在项目根目录运行此脚本"
    exit 1
fi

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  警告：有未提交的更改，是否继续？(y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ 部署已取消"
        exit 1
    fi
fi

# 安装依赖
echo "📦 安装依赖..."
npm install

# 构建项目
echo "🔨 构建项目..."
npm run build

# 检查构建是否成功
if [ ! -d "dist" ]; then
    echo "❌ 构建失败：dist 目录不存在"
    exit 1
fi

# 创建部署分支
echo "🌿 创建 gh-pages 分支..."
git checkout -B gh-pages

# 复制构建文件到根目录
echo "📁 复制构建文件..."
cp -r dist/* .

# 添加 .nojekyll 文件（GitHub Pages 优化）
touch .nojekyll

# 提交更改
echo "📝 提交更改..."
git add -A
git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')"

# 推送到 GitHub
echo "⬆️  推送到 GitHub..."
git push -f origin gh-pages

# 回到主分支
echo "🔄 回到主分支..."
git checkout main

echo "✅ 部署完成！"
echo "🌐 您的网站将在几分钟内可用："
echo "   https://$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\)\/\([^.]*\).*/\1.github.io\/\2/')/" 