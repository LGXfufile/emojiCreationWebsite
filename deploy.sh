#!/bin/bash

echo "🚀 简化部署脚本启动..."

# 检查是否在git仓库中
if [ ! -d ".git" ]; then
    echo "❌ 错误：当前目录不是git仓库"
    exit 1
fi

# 检查是否有更改
echo "🔍 检查文件更改状态..."
git status --porcelain > /tmp/git_status.txt

if [ ! -s /tmp/git_status.txt ]; then
    echo "✅ 没有检测到文件更改"
    echo "📋 当前状态："
    git status
    rm /tmp/git_status.txt
    exit 0
fi

# 显示更改的文件
echo "📝 检测到以下文件更改："
echo "----------------------------------------"
git status --short
echo "----------------------------------------"

# 询问是否要推送
echo ""
echo "❓ 是否要将更改推送到远程仓库？(y/N)"
read -r response

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "❌ 取消推送操作"
    rm /tmp/git_status.txt
    exit 0
fi

# 询问commit信息
echo ""
echo "📝 请输入commit备注信息："
read -r commit_message

# 如果没有输入commit信息，使用默认信息
if [ -z "$commit_message" ]; then
    commit_message="Update: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "使用默认commit信息: $commit_message"
fi

# 执行git操作
echo ""
echo "📦 添加所有更改到暂存区..."
git add .

echo "💾 提交更改..."
if git commit -m "$commit_message"; then
    echo "✅ 提交成功"
else
    echo "❌ 提交失败"
    rm /tmp/git_status.txt
    exit 1
fi

echo "⬆️  推送到远程仓库..."
current_branch=$(git branch --show-current)
if git push origin "$current_branch"; then
    echo "✅ 推送成功到分支: $current_branch"
else
    echo "❌ 推送失败"
    rm /tmp/git_status.txt
    exit 1
fi

# 显示最终状态
echo ""
echo "🎉 部署完成！"
echo "📋 当前状态："
git status
echo ""
echo "🔗 最近的提交："
git log --oneline -3

# 清理临时文件
rm /tmp/git_status.txt

echo "✨ 所有操作完成" 