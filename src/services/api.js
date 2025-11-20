import axios from 'axios'

// 使用相对路径，通过Nginx反向代理避免CORS和Mixed Content问题
// 生产环境：直接使用 /api/apps/... 路径，Nginx会代理到后端
// 开发环境：直接访问API服务器（仅在 localhost:3000 开发时）
const isDevelopment = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
const API_BASE_URL = isDevelopment ? 'http://113.106.62.42:9300' : ''
const API_KEY = 'app_WZCqYKovpijz2CO4T5RyiOkuAsP5qlKe'

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
      console.log('当前域名:', window.location.hostname)
      console.log('环境:', isDevelopment ? '开发环境' : '生产环境')
      console.log('API Base URL:', API_BASE_URL)
      console.log('完整URL:', fullURL)
      console.log('消息历史:', formattedMessages)
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

