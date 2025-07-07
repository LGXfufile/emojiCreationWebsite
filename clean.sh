#!/bin/bash

echo "🧹 清理项目..."

# 删除损坏的文件
rm -f src/i18n.js

# 重新创建干净的i18n.js文件
cat > src/i18n.js << 'EOF'
import { createI18n } from 'vue-i18n'

const messages = {
  'zh-CN': {
    title: '制作你的专属表情包',
    upload: '上传图片',
    uploadHint: '点击或拖拽图片到此区域',
    style: '选择风格',
    text: '输入文字（最多10字）',
    textPlaceholder: '输入表情包文字...',
    download: '下载表情包',
    preview: '预览',
    language: '语言',
    styles: {
      original: '原图',
      grayscale: '黑白',
      sepia: '怀旧',
      blur: '模糊',
      brightness: '高亮',
      contrast: '对比',
      saturate: '饱和',
      invert: '反色'
    }
  },
  'en-US': {
    title: 'Create Your Own Meme',
    upload: 'Upload Image',
    uploadHint: 'Click or drag image to this area',
    style: 'Choose Style',
    text: 'Enter Text (max 10 chars)',
    textPlaceholder: 'Enter meme text...',
    download: 'Download Meme',
    preview: 'Preview',
    language: 'Language',
    styles: {
      original: 'Original',
      grayscale: 'Grayscale',
      sepia: 'Sepia',
      blur: 'Blur',
      brightness: 'Brightness',
      contrast: 'Contrast',
      saturate: 'Saturate',
      invert: 'Invert'
    }
  }
}

export default createI18n({
  legacy: false,
  locale: 'zh-CN',
  fallbackLocale: 'en-US',
  messages
})
EOF

echo "✅ 文件已重新创建"
echo "🚀 现在可以运行: npm run dev" 