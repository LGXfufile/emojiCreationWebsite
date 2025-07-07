// 调试脚本 - 检查项目结构和依赖
import fs from 'fs'
import path from 'path'

console.log('🔍 开始调试检查...\n')

// 检查文件结构
const requiredFiles = [
  'package.json',
  'vite.config.js',
  'index.html',
  'src/main.js',
  'src/App.vue',
  'src/i18n.js',
  'src/composables/useCanvasUtils.js'
]

console.log('📁 检查文件结构:')
requiredFiles.forEach(file => {
  if (fs.existsSync(file)) {
    console.log(`✅ ${file}`)
  } else {
    console.log(`❌ ${file} - 文件不存在`)
  }
})

// 检查package.json
console.log('\n📦 检查package.json:')
try {
  const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'))
  console.log('✅ package.json 格式正确')
  console.log(`   - 项目名称: ${pkg.name}`)
  console.log(`   - 版本: ${pkg.version}`)
  console.log(`   - 依赖数量: ${Object.keys(pkg.dependencies || {}).length}`)
  console.log(`   - 开发依赖数量: ${Object.keys(pkg.devDependencies || {}).length}`)
} catch (err) {
  console.log('❌ package.json 格式错误')
}

console.log('\n🚀 运行方式:')
console.log('node debug.js')