import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 3000,
    host: true
  },
  build: {
    // 确保所有静态资源都被复制
    copyPublicDir: true,
    rollupOptions: {
      output: {
        // 优化输出
        manualChunks: undefined
      }
    }
  },
  // 确保sources目录可以被访问
  publicDir: 'public'
})

