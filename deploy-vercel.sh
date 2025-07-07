#!/bin/bash

echo "🚀 开始 Vercel 部署..."

# 检查是否安装了 Vercel CLI
if ! command -v vercel &> /dev/null; then
    echo "📦 安装 Vercel CLI..."
    npm install -g vercel
fi

# 构建项目
echo "🔨 构建项目..."
npm run build

# 部署到 Vercel
echo "⬆️  部署到 Vercel..."
vercel --prod

echo "✅ Vercel 部署完成！" 