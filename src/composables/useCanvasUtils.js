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