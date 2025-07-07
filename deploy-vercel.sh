#!/bin/bash

echo "🚀 开始Vercel自动部署..."

# 检查是否安装了Vercel CLI
if ! command -v vercel &> /dev/null; then
    echo "📦 安装Vercel CLI..."
    npm install -g vercel
fi

# 检查是否有未提交的更改
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "⚠️  检测到未提交的更改"
    echo "是否先提交更改？(y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "📝 请输入commit信息："
        read -r commit_message
        if [ -z "$commit_message" ]; then
            commit_message="Update for Vercel deployment: $(date '+%Y-%m-%d %H:%M:%S')"
        fi
        git add .
        git commit -m "$commit_message"
        git push
        echo "✅ 更改已提交并推送"
    fi
fi

# 构建项目
echo "🔨 构建项目..."
npm run build

# 部署到Vercel
echo "🚀 部署到Vercel..."
vercel --prod

echo "✅ 部署完成！"
echo "🌐 您的网站已部署到Vercel"