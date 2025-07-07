# 表情包生成器 / Meme Generator

一个基于Vue3的表情包生成工具，支持图片上传、风格转换、文字添加和下载功能。

## 功能特性

- 🖼️ 图片上传（支持拖拽）
- 🎨 多种风格滤镜（黑白、怀旧、模糊等）
- ✏️ 文字添加（最多10字）
- 📥 一键下载生成的表情包
- 🌍 国际化支持（中文/英文）
- 📱 响应式设计

## 技术栈

- Vue 3 + Composition API
- Vite
- Vue I18n
- Canvas API
- 原生JavaScript

## 安装和运行

```bash
# 安装依赖
npm install

# 开发模式
npm run dev

# 构建生产版本
npm run build

# 预览生产版本
npm run preview
```

## 部署

构建后的文件可以直接部署到任何静态文件服务器：

- GitHub Pages
- Vercel
- Netlify
- 或直接打开 `dist/index.html`

## 项目结构

```
.
├── public/
├── src/
│   ├── composables/
│   │   └── useCanvasUtils.js    # Canvas工具函数
│   ├── App.vue                  # 主应用组件
│   ├── i18n.js                  # 国际化配置
│   └── main.js                  # 入口文件
├── index.html
├── package.json
├── vite.config.js
└── README.md
```

## 使用说明

1. 点击上传区域或拖拽图片到页面
2. 选择想要的风格滤镜
3. 输入表情包文字（最多10字）
4. 点击下载按钮保存图片

## 浏览器支持

- Chrome/Edge 88+
- Firefox 78+
- Safari 14+

## License

MIT
```

现在项目已经创建完成！这是一个完整的表情包生成器，具有以下特点：

### 主要功能：
1. **图片上传** - 支持点击上传和拖拽上传
2. **风格滤镜** - 8种不同的图像处理效果
3. **文字添加** - 自动居中的文字叠加
4. **实时预览** - Canvas实时渲染
5. **一键下载** - 生成PNG格式图片
6. **国际化** - 中英文切换
7. **响应式设计** - 适配移动端

### 技术亮点：
- 使用Vue 3 Composition API
- 自定义Canvas图像处理算法
- 优雅的UI设计和动画效果
- 无需服务器，纯前端实现

您可以运行 `npm install` 然后 `npm run dev` 来启动开发服务器测试项目！ # emojiCreationWebsite
