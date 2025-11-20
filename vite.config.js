import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

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
      // 配置多页面应用
      input: {
        main: resolve(__dirname, 'index.html'),
        profile: resolve(__dirname, 'profile.html'),
        yuqinprofile: resolve(__dirname, 'yuqinprofile.html'),
        shaoyiprofile: resolve(__dirname, 'shaoyiprofile.html')
      },
      output: {
        // 优化输出
        manualChunks: undefined
      }
    }
  },
  // 确保sources目录可以被访问
  publicDir: 'public'
})

