<template>
  <div class="main-page-container min-h-screen transition-all duration-500 bg-gray-50 dark:bg-[rgb(17,24,39)]" :class="{ 'dark dark-mode': isDark }">
    <!-- 粒子容器 -->
    <div class="particles-container fixed inset-0 pointer-events-none overflow-hidden">
      <div class="particle" v-for="i in 9" :key="i" :style="{ left: `${i * 10}%`, animationDelay: `${i * 0.5}s` }"></div>
    </div>

    <div class="relative z-10 max-w-4xl mx-auto px-6 py-4">
      <!-- Header - 始终显示在顶部 -->
      <header class="flex items-center justify-between mb-6 py-2 sticky top-0 bg-gray-50 dark:bg-[rgb(17,24,39)] z-50">
        <div class="flex items-center gap-3">
          <img :src="isDark ? '/sources/logonight.png' : '/sources/logo3@2x.png'" alt="Logo" class="h-12">
        </div>
        <div class="flex items-center gap-3">
          <a
            href="mailto:renshi@cuhk.edu.cn"
            class="w-10 h-10 bg-white dark:bg-gray-800 rounded-full shadow-lg flex items-center justify-center transition-all duration-300 hover:scale-105 hover:bg-gray-100 dark:hover:bg-gray-700"
            title="renshi@cuhk.edu.cn"
          >
            <i class="ri-mail-line text-gray-900 dark:text-white text-xl"></i>
          </a>
          <a
            href="https://github.com/reneverland"
            target="_blank"
            class="w-10 h-10 bg-white dark:bg-gray-800 rounded-full shadow-lg flex items-center justify-center transition-all duration-300 hover:scale-105 hover:bg-gray-100 dark:hover:bg-gray-700"
            title="GitHub"
          >
            <i class="ri-github-fill text-gray-900 dark:text-white text-xl"></i>
          </a>
          <button 
            @click="toggleTheme" 
            class="w-10 h-10 bg-white dark:bg-gray-800 rounded-full shadow-lg flex items-center justify-center transition-all duration-300 hover:scale-105"
          >
            <i class="ri-sun-line text-yellow-500 text-xl" v-if="!isDark"></i>
            <i class="ri-moon-line text-blue-400 text-xl" v-else></i>
          </button>
          <button 
            @click="toggleLocale" 
            class="px-4 h-10 bg-white dark:bg-gray-800 rounded-full shadow-lg flex items-center justify-center transition-all duration-300 hover:scale-105"
          >
            <span class="text-sm font-medium text-gray-900 dark:text-white">{{ locale === 'zh' ? '中/EN' : 'EN/中' }}</span>
          </button>
        </div>
      </header>

      <!-- 聊天容器 -->
      <div ref="chatContainer" class="chat-container space-y-6 pb-32">
        <ChatBubble 
          v-for="(message, index) in messages" 
          :key="index"
          :message="message"
          :is-dark="isDark"
          :locale="locale"
          :is-profile-page="true"
          @select-qa="handleSelectQA"
          @view-avatar="showAvatarModal = true"
        />
      </div>
    </div>
  </div>

  <!-- 使用 Teleport 将输入框挂载到 body，避免受到 #app 的 transform 影响 -->
  <Teleport to="body">
    <InputBox 
      @send-message="handleSendMessage"
      @clear-chat="clearChat"
      :is-loading="isLoading"
      :locale="locale"
      :input-placeholder="t('profile.inputPlaceholder')"
      :quick-questions="quickQuestions"
      :is-profile-page="true"
    />
  </Teleport>

  <!-- 头像大图预览模态框 -->
  <Teleport to="body">
    <div 
      v-if="showAvatarModal" 
      class="fixed inset-0 z-[9999] flex items-center justify-center bg-black bg-opacity-80 backdrop-blur-sm"
      @click="showAvatarModal = false"
    >
      <div class="relative max-w-4xl max-h-[90vh] p-4">
        <button 
          @click="showAvatarModal = false"
          class="absolute top-6 right-6 w-10 h-10 bg-white dark:bg-gray-800 rounded-full flex items-center justify-center hover:scale-110 transition-transform duration-300 shadow-lg z-10"
          title="关闭"
        >
          <i class="ri-close-line text-gray-900 dark:text-white text-xl"></i>
        </button>
        <img 
          src="/sources/rendashi.jpeg" 
          alt="Ren Shi" 
          class="max-w-full max-h-[90vh] rounded-2xl shadow-2xl"
          @click.stop
        >
      </div>
    </div>
  </Teleport>
</template>

<script setup>
import { ref, onMounted, nextTick, computed, watch } from 'vue'
import ChatBubble from './components/ChatBubble.vue'
import InputBox from './components/InputBox.vue'
import { renProfileAPI } from './services/renprofile-api.js'
import { i18n } from './locales/index.js'

const isDark = ref(true) // 默认夜间模式
const locale = ref('zh') // 默认中文
const messages = ref([])
const isLoading = ref(false)
const chatContainer = ref(null)
const showAvatarModal = ref(false)

const toggleTheme = () => {
  isDark.value = !isDark.value
}

const toggleLocale = () => {
  locale.value = locale.value === 'zh' ? 'en' : 'zh'
}

// 监听 isDark 变化，同步更新 body 的 dark class
watch(isDark, (newVal) => {
  if (newVal) {
    document.body.classList.add('dark')
  } else {
    document.body.classList.remove('dark')
  }
}, { immediate: true })

// 获取当前语言的文本
const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[locale.value]
  for (const k of keys) {
    value = value?.[k]
  }
  return value || key
})

// 快捷问题
const quickQuestions = computed(() => [
  t.value('profile.quickQuestions.experience'),
  t.value('profile.quickQuestions.projects'),
  t.value('profile.quickQuestions.teaching')
])

// 清除对话
const clearChat = () => {
  const confirmText = locale.value === 'zh' 
    ? '确定要清除所有对话记录吗？' 
    : 'Are you sure you want to clear all chat history?'
  
  if (confirm(confirmText)) {
    // 重置为初始消息
    messages.value = getInitialMessages()
    scrollToBottom()
  }
}

const scrollToBottom = () => {
  nextTick(() => {
    // 使用 window.scrollTo 滚动整个页面到底部
    window.scrollTo({ 
      top: document.documentElement.scrollHeight, 
      behavior: 'smooth' 
    })
  })
}

// 处理用户选择QA建议（虽然不显示建议，但保留函数以避免警告）
const handleSelectQA = async (qa) => {
  console.log('handleSelectQA 被调用，但不应该被触发')
}

// 获取初始消息
const getInitialMessages = () => {
  return [
    {
      type: 'ai',
      content: 'profile.welcomeIntro',
      time: '刚刚'
    },
    {
      type: 'education-schools',
      time: '刚刚'
    },
    {
      type: 'ai',
      content: 'profile.workExperience',
      time: '刚刚'
    },
    {
      type: 'ai',
      content: 'profile.teaching',
      time: '刚刚'
    },
    {
      type: 'ai',
      content: 'profile.research',
      time: '刚刚'
    },
    {
      type: 'ai',
      content: 'profile.patent',
      time: '刚刚'
    },
    {
      type: 'profile-projects',
      time: '刚刚'
    }
  ]
}

const handleSendMessage = async (userMessage) => {
  console.log('=== 用户发送消息 ===', userMessage)
  
  // 添加用户消息
  messages.value.push({
    type: 'user',
    content: userMessage,
    time: '刚刚'
  })
  scrollToBottom()

  // 显示加载状态
  isLoading.value = true
  messages.value.push({
    type: 'ai',
    content: 'typing',
    time: '正在输入...'
  })
  scrollToBottom()

  try {
    // 构建消息历史
    const chatHistory = messages.value
      .filter(m => m.content !== 'typing' && (m.type === 'user' || m.type === 'ai'))
      .filter(m => !['profile.welcomeIntro', 'profile.workExperience', 'profile.teaching', 'profile.education', 'profile.research', 'profile.patent'].includes(m.content))
      // 过滤掉不完整的回复（只包含前缀的回复）
      .filter(m => {
        if (m.type === 'ai' || m.type === 'assistant') {
          const content = m.content || ''
          // 如果回复只是前缀且长度很短，过滤掉
          if (content.includes('根据知识库内容') && content.length < 50) {
            console.log('⚠️ 过滤掉不完整的历史回复:', content)
            return false
          }
        }
        return true
      })
      .slice(-10)
      .map(m => ({
        role: m.type === 'user' ? 'user' : 'assistant',
        content: m.content
      }))

    // 调用API
    const response = await renProfileAPI.sendMessage(chatHistory)
    
    // 移除加载消息
    messages.value = messages.value.filter(m => m.content !== 'typing')
    
    // 添加AI回复 - 支持多种响应格式
    console.log('=== 解析API响应 ===')
    console.log('完整响应对象:', JSON.stringify(response, null, 2))
    console.log('响应结构 keys:', Object.keys(response))
    
    // 检查是否有cbit_metadata
    if (response.cbit_metadata) {
      console.log('发现 cbit_metadata:', JSON.stringify(response.cbit_metadata, null, 2))
    }
    
    let aiResponse = '抱歉，我没能理解您的问题。'
    
    // 检查choices数组
    if (response.choices && Array.isArray(response.choices)) {
      console.log('✓ 找到 choices 数组，长度:', response.choices.length)
      console.log('choices[0] 内容:', JSON.stringify(response.choices[0], null, 2))
      
      const firstChoice = response.choices[0]
      if (firstChoice) {
        console.log('firstChoice.message 对象:', JSON.stringify(firstChoice.message, null, 2))
        
        // 尝试多种可能的路径
        if (firstChoice.message) {
          console.log('firstChoice.message keys:', Object.keys(firstChoice.message))
          
          // 检查content
          if (firstChoice.message.content && firstChoice.message.content.trim()) {
            const content = firstChoice.message.content
            console.log('✓ 找到 choices[0].message.content:', content)
            
            // 检测是否是不完整的前缀回复（source为no_result或未达阈值）
            const isIncompleteResponse = (
              content.includes('根据知识库内容') && 
              content.length < 50 &&
              (firstChoice.message.metadata?.source === 'no_result' || 
               firstChoice.message.metadata?.retrieval_confidence === 0)
            )
            
            if (isIncompleteResponse) {
              console.log('⚠️ 检测到不完整的前缀回复，重新请求完整答案')
              // 重新发送请求，强制要求生成完整答案
              try {
                const retryData = await renProfileAPI.sendCustomRequest({
                  messages: [{
                    role: 'user',
                    content: userMessage
                  }],
                  inputs: {},
                  response_mode: 'blocking',
                  conversation_id: '',
                  user: 'web-user',
                  files: [],
                  force_answer: true  // 强制要求完整答案
                })
                console.log('重试响应:', retryData)
                
                // 提取重试后的答案
                const retryAnswer = retryData.choices?.[0]?.message?.content || retryData.answer
                if (retryAnswer && retryAnswer.trim() && retryAnswer !== content) {
                  aiResponse = retryAnswer
                  console.log('✓ 使用重试后的完整答案:', aiResponse)
                } else {
                  // 如果重试还是不行，使用原内容或默认回复
                  aiResponse = content
                }
              } catch (error) {
                console.error('重试请求失败:', error)
                aiResponse = content
              }
            } else {
              aiResponse = content
            }
          } else if (firstChoice.message.metadata?.needs_confirmation) {
            // 检测到建议问题模式，自动选择第一个建议并获取答案
            console.log('✓ 检测到建议问题，自动获取答案')
            const suggestedQuestions = response.cbit_metadata?.suggested_questions || []
            
            if (suggestedQuestions.length > 0) {
              const firstSuggestion = suggestedQuestions[0]
              console.log('自动选择第一个建议:', firstSuggestion)
              
              // 发送确认请求获取答案
              try {
                const confirmData = await renProfileAPI.sendCustomRequest({
                  messages: [{
                    role: 'user',
                    content: userMessage
                  }],
                  inputs: {},
                  response_mode: 'blocking',
                  conversation_id: '',
                  user: 'web-user',
                  files: [],
                  selected_qa_id: firstSuggestion.qa_id
                })
                console.log('===== 确认响应完整数据 =====')
                console.log('完整JSON:', JSON.stringify(confirmData, null, 2))
                console.log('所有keys:', Object.keys(confirmData))
                
                // 尝试多种方式提取答案
                let extractedAnswer = null
                
                // 方式1: choices[0].message.content
                if (confirmData.choices?.[0]?.message?.content) {
                  extractedAnswer = confirmData.choices[0].message.content
                  console.log('✓ 从 choices[0].message.content 提取:', extractedAnswer)
                }
                // 方式2: answer 字段
                else if (confirmData.answer) {
                  extractedAnswer = confirmData.answer
                  console.log('✓ 从 answer 提取:', extractedAnswer)
                }
                // 方式3: message.content
                else if (confirmData.message?.content) {
                  extractedAnswer = confirmData.message.content
                  console.log('✓ 从 message.content 提取:', extractedAnswer)
                }
                // 方式4: data.answer
                else if (confirmData.data?.answer) {
                  extractedAnswer = confirmData.data.answer
                  console.log('✓ 从 data.answer 提取:', extractedAnswer)
                }
                // 方式5: result
                else if (confirmData.result) {
                  extractedAnswer = confirmData.result
                  console.log('✓ 从 result 提取:', extractedAnswer)
                }
                
                if (!extractedAnswer || extractedAnswer.trim() === '') {
                  console.error('❌ 未能从确认响应中提取答案')
                  console.error('响应结构:', confirmData)
                  aiResponse = '抱歉，未能获取答案。'
                } else {
                  aiResponse = extractedAnswer
                  console.log('✓ 最终使用的答案:', aiResponse)
                }
              } catch (error) {
                console.error('自动确认请求失败:', error)
                aiResponse = '抱歉，获取答案时出现问题。'
              }
            } else {
              aiResponse = '抱歉，未找到相关答案。'
            }
          } else if (firstChoice.message.text) {
            console.log('✓ 找到 choices[0].message.text:', firstChoice.message.text)
            aiResponse = firstChoice.message.text
          } else if (typeof firstChoice.message === 'string') {
            console.log('✓ message 是字符串:', firstChoice.message)
            aiResponse = firstChoice.message
          } else {
            console.error('❌ message 对象中未找到content或text，message内容:', firstChoice.message)
          }
        } else if (firstChoice.text) {
          console.log('✓ 找到 choices[0].text:', firstChoice.text)
          aiResponse = firstChoice.text
        } else if (firstChoice.content) {
          console.log('✓ 找到 choices[0].content:', firstChoice.content)
          aiResponse = firstChoice.content
        } else if (firstChoice.delta?.content) {
          console.log('✓ 找到 choices[0].delta.content:', firstChoice.delta.content)
          aiResponse = firstChoice.delta.content
        } else {
          console.error('❌ choices[0] 中未找到内容，keys:', Object.keys(firstChoice))
        }
      }
    } else if (response.answer) {
      console.log('✓ 找到 response.answer:', response.answer)
      aiResponse = response.answer
    } else if (response.message) {
      console.log('✓ 找到 response.message:', response.message)
      aiResponse = response.message
    } else if (response.text) {
      console.log('✓ 找到 response.text:', response.text)
      aiResponse = response.text
    } else {
      console.error('❌ 未找到有效的响应内容')
      console.error('响应的所有keys:', Object.keys(response))
    }
    
    console.log('最终使用的回复:', aiResponse)
    
    messages.value.push({
      type: 'ai',
      content: aiResponse,
      time: '刚刚'
    })
  } catch (error) {
    console.error('发送消息失败:', error.response?.data || error)
    
    // 显示更详细的错误信息给用户
    let errorMessage = '抱歉，连接服务器时出现问题，请稍后再试。'
    
    if (error.response?.data?.detail) {
      console.error('详细错误信息:', JSON.stringify(error.response.data.detail, null, 2))
      
      // 尝试提取有用的错误信息
      if (Array.isArray(error.response.data.detail)) {
        const details = error.response.data.detail.map(d => d.msg || d.message || JSON.stringify(d)).join('; ')
        errorMessage = `API错误: ${details}`
      }
    }
    
    messages.value = messages.value.filter(m => m.content !== 'typing')
    messages.value.push({
      type: 'ai',
      content: errorMessage,
      time: '刚刚'
    })
  } finally {
    isLoading.value = false
    scrollToBottom()
  }
}

// 简单的自动回复逻辑
const getAutoReply = (message) => {
  const lowerMessage = message.toLowerCase()
  
  // 工作经历相关
  if (lowerMessage.includes('work') || lowerMessage.includes('工作') || lowerMessage.includes('experience') || lowerMessage.includes('经历') || lowerMessage.includes('cbit')) {
    return 'profile.workExperience'
  }
  
  // 教学相关
  if (lowerMessage.includes('teach') || lowerMessage.includes('教学') || lowerMessage.includes('python') || lowerMessage.includes('course') || lowerMessage.includes('课程') || lowerMessage.includes('iba6002')) {
    return 'profile.teaching'
  }
  
  // 教育背景
  if (lowerMessage.includes('education') || lowerMessage.includes('教育') || lowerMessage.includes('duke') || lowerMessage.includes('university') || lowerMessage.includes('学校') || lowerMessage.includes('大学') || lowerMessage.includes('学历')) {
    return 'profile.education'
  }
  
  // 研究兴趣
  if (lowerMessage.includes('research') || lowerMessage.includes('研究') || lowerMessage.includes('interest') || lowerMessage.includes('兴趣')) {
    return 'profile.research'
  }
  
  // 专利
  if (lowerMessage.includes('patent') || lowerMessage.includes('专利')) {
    return 'profile.patent'
  }
  
  // 项目
  if (lowerMessage.includes('project') || lowerMessage.includes('项目') || lowerMessage.includes('ai') || lowerMessage.includes('作品')) {
    return 'profile.projectsTitle'
  }
  
  // 默认回复
  return locale.value === 'zh' 
    ? '感谢您的提问！您可以询问我关于工作经历、教学经历、教育背景、研究兴趣、专利或AI项目的任何问题。' 
    : 'Thank you for your question! You can ask me anything about work experience, teaching experience, education, research interests, patents, or AI projects.'
}

// 初始化静态消息
onMounted(() => {
  messages.value = getInitialMessages()
})
</script>

<style>
/* 确保整个页面背景在夜间模式下是深色 */
body:has(.dark.main-page-container) {
  background: rgb(17, 24, 39) !important;
  min-height: 100vh;
}

html {
  background: transparent;
}

/* 粒子动画效果 */
.particles-container {
  z-index: 1;
}

.particle {
  position: absolute;
  top: -10px;
  width: 6px;
  height: 6px;
  background: rgba(59, 130, 246, 0.6);
  border-radius: 50%;
  animation: fall 15s infinite linear;
  pointer-events: none;
  box-shadow: 0 0 10px rgba(59, 130, 246, 0.5);
}

@keyframes fall {
  0% {
    top: -10px;
    opacity: 0;
  }
  10% {
    opacity: 1;
  }
  90% {
    opacity: 1;
  }
  100% {
    top: 100vh;
    opacity: 0;
  }
}

.dark .particle {
  background: rgba(147, 197, 253, 0.7);
  box-shadow: 0 0 15px rgba(147, 197, 253, 0.6);
}
</style>

