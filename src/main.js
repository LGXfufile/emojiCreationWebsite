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