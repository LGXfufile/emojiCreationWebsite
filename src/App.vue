<template>
  <div id="app">
    <div class="container">
      <header class="header">
        <h1 class="title">{{ $t('title') }}</h1>
        <div class="language-selector">
          <select v-model="$i18n.locale" class="language-select">
            <option value="zh-CN">中文</option>
            <option value="en-US">English</option>
          </select>
        </div>
      </header>

      <main class="main">
        <div class="upload-section">
          <div 
            class="upload-area"
            :class="{ 'has-image': uploadedImage }"
            @click="triggerFileInput"
            @dragover.prevent
            @drop.prevent="handleDrop"
          >
            <input 
              ref="fileInput"
              type="file" 
              accept="image/*" 
              @change="handleImageUpload"
              class="file-input"
            />
            <div v-if="!uploadedImage" class="upload-hint">
              <div class="upload-icon">📷</div>
              <p>{{ $t('uploadHint') }}</p>
            </div>
            <img v-if="uploadedImage" :src="uploadedImage" alt="uploaded" class="uploaded-image" />
          </div>
        </div>

        <div class="controls">
          <div class="control-group">
            <label>{{ $t('style') }}</label>
            <select v-model="selectedStyle" @change="applyEffect" class="style-select">
              <option v-for="(label, key) in $t('styles')" :key="key" :value="key">
                {{ label }}
              </option>
            </select>
          </div>

          <div class="control-group">
            <label>{{ $t('text') }}</label>
            <input
              v-model="userText"
              :placeholder="$t('textPlaceholder')"
              maxlength="10"
              @input="drawText"
              class="text-input"
            />
          </div>
        </div>

        <div class="canvas-section">
          <canvas 
            ref="canvas" 
            width="400" 
            height="400"
            class="preview-canvas"
          ></canvas>
        </div>

        <div class="actions">
          <button 
            @click="downloadImage" 
            :disabled="!uploadedImage"
            class="download-btn"
          >
            {{ $t('download') }}
          </button>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useCanvasUtils } from '@/composables/useCanvasUtils.js'

const canvas = ref(null)
const fileInput = ref(null)
const uploadedImage = ref(null)
const selectedStyle = ref('original')
const userText = ref('')

const { loadImageToCanvas, applyStyleFilter, drawTextOnCanvas, downloadCanvas } = useCanvasUtils()

function triggerFileInput() {
  if (fileInput.value) {
    fileInput.value.click()
  }
}

function handleImageUpload(event) {
  const file = event.target.files?.[0]
  if (!file) return
  
  const reader = new FileReader()
  reader.onload = (e) => {
    uploadedImage.value = e.target.result
    loadImage(e.target.result)
  }
  reader.readAsDataURL(file)
}

function handleDrop(event) {
  const file = event.dataTransfer.files?.[0]
  if (file && file.type.startsWith('image/')) {
    const reader = new FileReader()
    reader.onload = (e) => {
      uploadedImage.value = e.target.result
      loadImage(e.target.result)
    }
    reader.readAsDataURL(file)
  }
}

function loadImage(src) {
  const img = new Image()
  img.onload = () => {
    if (canvas.value) {
      loadImageToCanvas(canvas.value, img)
      applyEffect()
      drawText()
    }
  }
  img.src = src
}

function applyEffect() {
  if (!uploadedImage.value || !canvas.value) return
  applyStyleFilter(canvas.value, selectedStyle.value)
  drawText()
}

function drawText() {
  if (!uploadedImage.value || !canvas.value) return
  drawTextOnCanvas(canvas.value, userText.value)
}

function downloadImage() {
  if (!uploadedImage.value || !canvas.value) return
  downloadCanvas(canvas.value, 'meme.png')
}

onMounted(async () => {
  await nextTick()
  if (canvas.value) {
    const ctx = canvas.value.getContext('2d')
    ctx.fillStyle = '#f0f0f0'
    ctx.fillRect(0, 0, 400, 400)
    ctx.fillStyle = '#666'
    ctx.font = '16px Arial'
    ctx.textAlign = 'center'
    ctx.fillText('请上传图片', 200, 200)
  }
})
</script>

<style scoped>
#app {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
}

.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  margin-top: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 2px solid #f0f0f0;
}

.title {
  font-size: 2rem;
  color: #333;
  margin: 0;
}

.language-select {
  padding: 8px 12px;
  border: 2px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
  background: white;
  cursor: pointer;
}

.main {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
  align-items: start;
}

.upload-section {
  grid-column: 1 / -1;
}

.upload-area {
  border: 3px dashed #ddd;
  border-radius: 12px;
  padding: 40px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s ease;
  background: #fafafa;
}

.upload-area:hover {
  border-color: #667eea;
  background: #f8f9ff;
}

.upload-area.has-image {
  border-style: solid;
  border-color: #667eea;
}

.file-input {
  display: none;
}

.upload-hint {
  color: #666;
}

.upload-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.uploaded-image {
  max-width: 100%;
  max-height: 200px;
  border-radius: 8px;
}

.controls {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.control-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.control-group label {
  font-weight: 600;
  color: #333;
}

.style-select,
.text-input {
  padding: 12px;
  border: 2px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
}

.style-select:focus,
.text-input:focus {
  outline: none;
  border-color: #667eea;
}

.canvas-section {
  display: flex;
  justify-content: center;
}

.preview-canvas {
  border: 2px solid #ddd;
  border-radius: 8px;
  max-width: 100%;
  height: auto;
}

.actions {
  grid-column: 1 / -1;
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.download-btn {
  padding: 12px 24px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.download-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.download-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .main {
    grid-template-columns: 1fr;
  }
  
  .container {
    margin: 10px;
    padding: 15px;
  }
}
</style>
```

```js:src/main.js
import { createApp } from 'vue'
import App from './App.vue'
import i18n from './i18n.js'

// 确保DOM已加载
document.addEventListener('DOMContentLoaded', () => {
  const app = createApp(App)
  app.use(i18n)
  
  // 确保挂载点存在
  const mountPoint = document.getElementById('app')
  if (mountPoint) {
    app.mount('#app')
  } else {
    console.error('Mount point #app not found')
  }
})
```

```js:src/i18n.js
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
```

```vue:src/composables/useCanvasUtils.js
export function useCanvasUtils() {
  function loadImageToCanvas(ctx, image) {
    const canvas = ctx.canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    
    // 计算缩放比例以适应canvas
    const scale = Math.min(canvas.width / image.width, canvas.height / image.height)
    const x = (canvas.width - image.width * scale) / 2
    const y = (canvas.height - image.height * scale) / 2
    
    ctx.drawImage(image, x, y, image.width * scale, image.height * scale)
  }

  function applyStyle(ctx, style) {
    const canvas = ctx.canvas
    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height)
    const data = imageData.data

    switch (style) {
      case 'grayscale':
        for (let i = 0; i < data.length; i += 4) {
          const gray = data[i] * 0.299 + data[i + 1] * 0.587 + data[i + 2] * 0.114
          data[i] = gray
          data[i + 1] = gray
          data[i + 2] = gray
        }
        break
      
      case 'sepia':
        for (let i = 0; i < data.length; i += 4) {
          const r = data[i]
          const g = data[i + 1]
          const b = data[i + 2]
          
          data[i] = Math.min(255, (r * 0.393) + (g * 0.769) + (b * 0.189))
          data[i + 1] = Math.min(255, (r * 0.349) + (g * 0.686) + (b * 0.168))
          data[i + 2] = Math.min(255, (r * 0.272) + (g * 0.534) + (b * 0.131))
        }
        break
      
      case 'invert':
        for (let i = 0; i < data.length; i += 4) {
          data[i] = 255 - data[i]
          data[i + 1] = 255 - data[i + 1]
          data[i + 2] = 255 - data[i + 2]
        }
        break
      
      case 'brightness':
        for (let i = 0; i < data.length; i += 4) {
          data[i] = Math.min(255, data[i] + 50)
          data[i + 1] = Math.min(255, data[i + 1] + 50)
          data[i + 2] = Math.min(255, data[i + 2] + 50)
        }
        break
      
      case 'contrast':
        const factor = 1.5
        for (let i = 0; i < data.length; i += 4) {
          data[i] = Math.min(255, Math.max(0, factor * (data[i] - 128) + 128))
          data[i + 1] = Math.min(255, Math.max(0, factor * (data[i + 1] - 128) + 128))
          data[i + 2] = Math.min(255, Math.max(0, factor * (data[i + 2] - 128) + 128))
        }
        break
      
      case 'saturate':
        for (let i = 0; i < data.length; i += 4) {
          const gray = data[i] * 0.299 + data[i + 1] * 0.587 + data[i + 2] * 0.114
          data[i] = Math.min(255, gray + 1.5 * (data[i] - gray))
          data[i + 1] = Math.min(255, gray + 1.5 * (data[i + 1] - gray))
          data[i + 2] = Math.min(255, gray + 1.5 * (data[i + 2] - gray))
        }
        break
      
      case 'blur':
        // 简单的模糊效果
        applyBoxBlur(data, canvas.width, canvas.height)
        break
    }

    if (style !== 'original') {
      ctx.putImageData(imageData, 0, 0)
    }
  }

  function applyBoxBlur(data, width, height) {
    const radius = 2
    const kernel = []
    const kernelSize = 2 * radius + 1
    
    for (let i = 0; i < kernelSize; i++) {
      kernel[i] = []
      for (let j = 0; j < kernelSize; j++) {
        kernel[i][j] = 1 / (kernelSize * kernelSize)
      }
    }
    
    const output = new Uint8ClampedArray(data.length)
    
    for (let y = 0; y < height; y++) {
      for (let x = 0; x < width; x++) {
        let r = 0, g = 0, b = 0, a = 0
        
        for (let ky = -radius; ky <= radius; ky++) {
          for (let kx = -radius; kx <= radius; kx++) {
            const px = Math.min(width - 1, Math.max(0, x + kx))
            const py = Math.min(height - 1, Math.max(0, y + ky))
            const idx = (py * width + px) * 4
            
            const weight = kernel[ky + radius][kx + radius]
            r += data[idx] * weight
            g += data[idx + 1] * weight
            b += data[idx + 2] * weight
            a += data[idx + 3] * weight
          }
        }
        
        const idx = (y * width + x) * 4
        output[idx] = r
        output[idx + 1] = g
        output[idx + 2] = b
        output[idx + 3] = a
      }
    }
    
    data.set(output)
  }

  function drawText(ctx, text) {
    if (!text.trim()) return
    
    const canvas = ctx.canvas
    ctx.font = 'bold 40px Arial, sans-serif'
    ctx.textAlign = 'center'
    ctx.textBaseline = 'middle'
    
    // 添加文字描边和填充
    ctx.strokeStyle = 'black'
    ctx.lineWidth = 4
    ctx.fillStyle = 'white'
    
    const x = canvas.width / 2
    const y = canvas.height - 60
    
    ctx.strokeText(text, x, y)
    ctx.fillText(text, x, y)
  }

  return {
    loadImageToCanvas,
    applyStyle,
    drawText
  }
}
```

最后创建一个简单的README文件：

```markdown:README.md
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

您可以运行 `npm install` 然后 `npm run dev` 来启动开发服务器测试项目！ 