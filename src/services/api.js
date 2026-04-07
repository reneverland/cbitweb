import axios from 'axios'

// ========== API配置 ==========
// 检测当前环境
const isDevelopment = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'

// 后端API服务器地址
// 开发环境：使用相对路径，通过Vite proxy代理到后端（避免CORS问题）
// 生产环境：使用相对路径，通过Nginx反向代理到后端（避免HTTPS->HTTP的Mixed Content问题）
const API_BASE_URL = ''

// API密钥（必须与后端配置一致）
const API_KEY = 'app_WZCqYKovpijz2CO4T5RyiOkuAsP5qlKe'

// 日志输出当前配置
console.log('========== CBIT API配置 ==========')
console.log('🌐 当前访问域名:', window.location.hostname)
console.log('📍 环境:', isDevelopment ? '开发环境 (localhost)' : '生产环境')
console.log('🔗 API Base URL:', API_BASE_URL || '(相对路径，使用Nginx代理)')
console.log('🎯 完整端点:', (API_BASE_URL || '') + '/api/apps/cbit-official/chat/completions')
console.log('🔑 API Key:', API_KEY.substring(0, 20) + '...')
console.log('==================================')

export const chatAPI = {
  async sendMessage(messages) {
    try {
      // 格式化消息为API期望的格式
      const formattedMessages = messages.map(m => ({
        role: m.role,
        content: m.content
      }))
      
      const requestBody = {
        messages: formattedMessages,
        inputs: {},
        response_mode: 'blocking',
        conversation_id: '',
        user: 'web-user',
        files: []
      }
      
      const fullURL = `${API_BASE_URL}/api/apps/cbit-official/chat/completions`
      
      console.log('=== 发送API请求 ===')
      console.log('🌐 当前域名:', window.location.hostname)
      console.log('📍 环境:', isDevelopment ? '开发环境' : '生产环境')
      console.log('🔗 API Base URL:', API_BASE_URL)
      console.log('🎯 完整URL:', fullURL)
      console.log('🔑 API密钥:', API_KEY.substring(0, 20) + '...')
      console.log('📝 消息历史条数:', formattedMessages.length)
      console.log('📦 请求体:', JSON.stringify(requestBody, null, 2))
      
      const response = await axios.post(
        fullURL,
        requestBody,
        {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${API_KEY}`
          },
          timeout: 60000 // 60秒超时
        }
      )
      
      console.log('=== API响应成功 ===')
      console.log('响应数据:', response.data)
      return response.data
    } catch (error) {
      console.error('API调用错误 - 完整信息:', {
        status: error.response?.status,
        statusText: error.response?.statusText,
        data: error.response?.data,
        detail: error.response?.data?.detail
      })
      
      // 详细打印detail数组
      if (error.response?.data?.detail) {
        console.error('错误详情 (detail):', JSON.stringify(error.response.data.detail, null, 2))
      }
      
      throw error
    }
  },

  // 发送带有额外参数的自定义请求（如selected_qa_id, force_answer等）
  async sendCustomRequest(requestBody) {
    try {
      const fullURL = `${API_BASE_URL}/api/apps/cbit-official/chat/completions`
      
      console.log('=== 发送自定义API请求 ===')
      console.log('当前域名:', window.location.hostname)
      console.log('环境:', isDevelopment ? '开发环境' : '生产环境')
      console.log('API Base URL:', API_BASE_URL)
      console.log('完整URL:', fullURL)
      console.log('请求体:', requestBody)
      
      const response = await axios.post(
        fullURL,
        requestBody,
        {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${API_KEY}`
          },
          timeout: 60000 // 60秒超时
        }
      )
      
      console.log('=== 自定义API响应成功 ===')
      console.log('响应数据:', response.data)
      return response.data
    } catch (error) {
      console.error('自定义API调用错误 - 完整信息:', {
        status: error.response?.status,
        statusText: error.response?.statusText,
        data: error.response?.data,
        detail: error.response?.data?.detail
      })
      
      if (error.response?.data?.detail) {
        console.error('错误详情 (detail):', JSON.stringify(error.response.data.detail, null, 2))
      }
      
      throw error
    }
  }
}

