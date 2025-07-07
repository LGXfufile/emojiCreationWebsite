#!/bin/bash

echo "🎯 表情包生成器完整工作流"
echo "=========================="

case "$1" in
    "dev")
        echo "🚀 启动开发服务器..."
        npm run dev
        ;;
    "build")
        echo "🔨 构建项目..."
        npm run build
        ;;
    "preview")
        echo "👀 预览构建结果..."
        npm run preview
        ;;
    "deploy")
        echo "🚀 部署到 GitHub Pages..."
        npm run deploy
        ;;
    "deploy:vercel")
        echo "🚀 部署到 Vercel..."
        npm run deploy:vercel
        ;;
    "deploy:netlify")
        echo "🚀 部署到 Netlify..."
        npm run deploy:netlify
        ;;
    *)
        echo "使用方法:"
        echo "  ./workflow.sh dev          - 启动开发服务器"
        echo "  ./workflow.sh build        - 构建项目"
        echo "  ./workflow.sh preview      - 预览构建结果"
        echo "  ./workflow.sh deploy       - 部署到 GitHub Pages"
        echo "  ./workflow.sh deploy:vercel - 部署到 Vercel"
        echo "  ./workflow.sh deploy:netlify - 部署到 Netlify"
        ;;
esac 