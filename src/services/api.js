import axios from 'axios'

// 使用相对路径，通过Nginx反向代理避免CORS问题
// 生产环境：/api/ 会被Nginx代理到 http://113.106.62.42:9300/
// 开发环境：直接访问API服务器
const API_BASE_URL = import.meta.env.DEV ? 'http://113.106.62.42:9300' : '/api'
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
      
      console.log('=== 发送API请求 ===')
      console.log('消息历史:', formattedMessages)
      console.log('请求体:', requestBody)
      
      const response = await axios.post(
        `${API_BASE_URL}/api/apps/cbit-official/chat/completions`,
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
  }
}

