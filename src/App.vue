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
          <!-- ICSF会议系列按钮 -->
          <button 
            @click="toggleICSFMenu" 
            class="px-4 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full shadow-lg flex items-center gap-2 transition-all duration-300 hover:scale-105 hover:shadow-xl relative"
            :title="locale === 'zh' ? 'ICSF会议系列' : 'ICSF Conference Series'"
          >
            <i class="ri-calendar-event-line text-white text-lg"></i>
            <span class="text-sm font-bold text-white">ICSF</span>
            <!-- 红点提示 -->
            <span class="absolute -top-1 -right-1 w-3 h-3 bg-red-500 rounded-full animate-pulse"></span>
          </button>
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
      <div ref="chatContainer" class="chat-container space-y-6 pb-32 scroll-mt-24">
        <ChatBubble 
          v-for="(message, index) in messages" 
          :key="index"
          :message="message"
          :is-dark="isDark"
          :locale="locale"
          @select-qa="handleSelectQA"
          @view-member-avatar="handleViewMemberAvatar"
        />
      </div>
    </div>
  </div>

  <!-- ICSF会议系列下拉菜单 -->
  <Teleport to="body">
    <div 
      v-if="showICSFMenu" 
      class="fixed inset-0 z-[9998] bg-black bg-opacity-30 backdrop-blur-sm"
      @click="showICSFMenu = false"
    >
      <div 
        class="absolute top-16 right-6 bg-white dark:bg-gray-800 rounded-2xl shadow-2xl p-6 w-80 max-h-[70vh] overflow-y-auto"
        @click.stop
      >
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
            <i class="ri-calendar-event-line text-blue-500"></i>
            {{ locale === 'zh' ? 'ICSF会议系列' : 'ICSF Conference Series' }}
          </h3>
          <button 
            @click="showICSFMenu = false"
            class="w-8 h-8 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 flex items-center justify-center transition-colors"
          >
            <i class="ri-close-line text-gray-500 dark:text-gray-400"></i>
          </button>
        </div>
        
        <p class="text-sm text-gray-600 dark:text-gray-400 mb-4">
          {{ locale === 'zh' ? 'International Conference on Smart Finance（智能金融国际会议）' : 'International Conference on Smart Finance' }}
        </p>

        <div class="space-y-2">
          <a 
            v-for="year in icsfYears" 
            :key="year.year"
            :href="year.link" 
            target="_blank"
            class="block p-3 rounded-xl bg-gradient-to-r from-blue-50 to-purple-50 dark:from-gray-700 dark:to-gray-600 hover:shadow-md transition-all duration-300 group"
          >
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-full bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-white font-bold text-sm">
                  {{ year.year }}
                </div>
                <div>
                  <div class="font-semibold text-gray-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                    ICSF {{ year.year }}
                  </div>
                  <div class="text-xs text-gray-500 dark:text-gray-400">
                    {{ year.location }}
                  </div>
                </div>
              </div>
              <i class="ri-arrow-right-line text-gray-400 group-hover:text-blue-600 group-hover:translate-x-1 transition-all"></i>
            </div>
          </a>
        </div>
      </div>
    </div>
  </Teleport>

  <!-- 使用 Teleport 将输入框挂载到 body，避免受到 #app 的 transform 影响 -->
  <Teleport to="body">
    <InputBox 
      @send-message="handleSendMessage"
      @clear-chat="clearChat"
      :is-loading="isLoading"
      :locale="locale"
    />
  </Teleport>

  <!-- 团队成员头像大图预览模态框 -->
  <Teleport to="body">
    <div 
      v-if="selectedMember" 
      class="fixed inset-0 z-[9999] flex items-center justify-center bg-black bg-opacity-80 backdrop-blur-sm"
      @click="selectedMember = null"
    >
      <div class="relative max-w-4xl max-h-[90vh] p-4">
        <button 
          @click="selectedMember = null"
          class="absolute top-6 right-6 w-10 h-10 bg-white dark:bg-gray-800 rounded-full flex items-center justify-center hover:scale-110 transition-transform duration-300 shadow-lg z-10"
          :title="locale === 'zh' ? '关闭' : 'Close'"
        >
          <i class="ri-close-line text-gray-900 dark:text-white text-xl"></i>
        </button>
        <div class="text-center mb-4">
          <h3 class="text-white text-xl font-semibold">{{ selectedMember.name }}</h3>
          <p class="text-gray-300 text-sm">{{ selectedMember.nameEn }}</p>
        </div>
        <img 
          :src="selectedMember.avatar" 
          :alt="selectedMember.name" 
          class="max-w-full max-h-[80vh] rounded-2xl shadow-2xl mx-auto"
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
import { chatAPI } from './services/api.js'
import { i18n } from './locales/index.js'

const isDark = ref(false)
const locale = ref('zh') // 默认中文
const messages = ref([])
const isLoading = ref(false)
const chatContainer = ref(null)
const selectedMember = ref(null)
const showICSFMenu = ref(false)

// ICSF会议系列数据
const icsfYears = ref([
  { year: '2024', location: 'Hong Kong', link: '/sources/ICSF/ICSF24/index.html' },
  { year: '2023', location: 'Hong Kong', link: '/sources/ICSF/ICSF23/index.html' },
  { year: '2022', location: 'Hong Kong (Online)', link: '/sources/ICSF/ICSF22/index.html' },
  { year: '2021', location: 'Hong Kong (Online)', link: '/sources/ICSF/ICSF21/index.html' },
  { year: '2020', location: 'Hong Kong (Online)', link: '/sources/ICSF/ICSF20/index.html' },
  { year: '2019', location: 'Hong Kong', link: '/sources/ICSF/ICSF19/index.html' },
  { year: '2018', location: 'Hong Kong', link: '/sources/ICSF/ICSF18/index.html' },
  { year: '2017', location: 'Hong Kong', link: '/sources/ICSF/ICSF17/index.html' },
  { year: '2016', location: 'Hong Kong', link: '/sources/ICSF/ICSF16/index.html' },
])

const toggleTheme = () => {
  isDark.value = !isDark.value
}

const toggleLocale = () => {
  locale.value = locale.value === 'zh' ? 'en' : 'zh'
}

const toggleICSFMenu = () => {
  showICSFMenu.value = !showICSFMenu.value
}

const handleViewMemberAvatar = (memberInfo) => {
  selectedMember.value = memberInfo
}

// 监听 isDark 变化，同步更新 body 的 dark class
watch(isDark, (newVal) => {
  if (newVal) {
    document.body.classList.add('dark')
  } else {
    document.body.classList.remove('dark')
  }
}, { immediate: true })

// 清除对话
const clearChat = () => {
  const confirmText = locale.value === 'zh' 
    ? '确定要清除所有对话记录吗？' 
    : 'Are you sure you want to clear all chat history?'
  
  if (confirm(confirmText)) {
    // 重置为初始消息
    messages.value = [
      {
        type: 'ai',
        content: 'welcomeIntro',
        time: '刚刚'
      },
      {
        type: 'ai',
        content: 'intro',
        time: '刚刚'
      },
      {
        type: 'ai',
        content: 'structure',
        time: '刚刚'
      },
      {
        type: 'ai',
        content: 'mission',
        time: '刚刚'
      },
      {
        type: 'news',
        time: '刚刚'
      },
      {
        type: 'team',
        time: '刚刚'
      },
      {
        type: 'events',
        time: '刚刚'
      },
      {
        type: 'projects',
        time: '刚刚'
      }
    ]
    scrollToBottom()
  }
}

// 处理用户选择QA建议
const handleSelectQA = async (qa) => {
  console.log('=== 用户选择了QA ===')
  console.log('QA对象完整内容:', JSON.stringify(qa, null, 2))
  console.log('QA对象keys:', Object.keys(qa))
  
  // 确保对话区域可见
  scrollToChatView()
  
  // 添加用户选择的问题
  const questionText = qa.question || qa.text || qa.title || qa.query || '选中的问题'
  messages.value.push({
    type: 'user',
    content: questionText,
    time: '刚刚'
  })
  
  // 尝试从多个可能的字段提取答案
  let answerText = null
  
  if (qa.answer) {
    console.log('✓ 找到 qa.answer:', qa.answer)
    answerText = qa.answer
  } else if (qa.content) {
    console.log('✓ 找到 qa.content:', qa.content)
    answerText = qa.content
  } else if (qa.response) {
    console.log('✓ 找到 qa.response:', qa.response)
    answerText = qa.response
  } else if (qa.text && qa.text !== questionText) {
    console.log('✓ 找到 qa.text (不同于问题):', qa.text)
    answerText = qa.text
  } else if (qa.data?.answer) {
    console.log('✓ 找到 qa.data.answer:', qa.data.answer)
    answerText = qa.data.answer
  } else if (qa.metadata?.answer) {
    console.log('✓ 找到 qa.metadata.answer:', qa.metadata.answer)
    answerText = qa.metadata.answer
  } else {
    console.error('❌ 未找到答案字段')
    console.error('尝试过的字段: answer, content, response, text, data.answer, metadata.answer')
  }
  
  // 如果有答案，直接显示；否则向后端请求
  if (answerText) {
    messages.value.push({
      type: 'ai',
      content: answerText,
      time: '刚刚'
    })
    scrollToBottom()
  } else {
    // 没有答案，需要向后端发送确认请求
    console.log('没有本地答案，向后端请求...')
    
    // 如果有qa_id，发送确认请求
    if (qa.id || qa.qa_id) {
      isLoading.value = true
      messages.value.push({
        type: 'ai',
        content: 'typing',
        time: '正在输入...'
      })
      scrollToBottom()
      
      try {
        // 发送确认选择的请求
        const confirmBody = {
          messages: [{
            role: 'user',
            content: questionText
          }],
          inputs: {},
          response_mode: 'blocking',
          conversation_id: '',
          user: 'web-user',
          files: [],
          selected_qa_id: qa.id || qa.qa_id
        }
        
        console.log('发送确认请求:', confirmBody)
        
        const response = await fetch('/api/apps/cbit-official/chat/completions', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer app_WZCqYKovpijz2CO4T5RyiOkuAsP5qlKe'
          },
          body: JSON.stringify(confirmBody)
        })
        
        const data = await response.json()
        console.log('确认响应:', data)
        
        // 移除loading
        messages.value = messages.value.filter(m => m.content !== 'typing')
        
        // 提取答案
        const answer = data.choices?.[0]?.message?.content || data.answer || '抱歉，未找到答案。'
        messages.value.push({
          type: 'ai',
          content: answer,
          time: '刚刚'
        })
      } catch (error) {
        console.error('确认请求失败:', error)
        messages.value = messages.value.filter(m => m.content !== 'typing')
        messages.value.push({
          type: 'ai',
          content: '抱歉，获取答案时出现问题。',
          time: '刚刚'
        })
      } finally {
        isLoading.value = false
        scrollToBottom()
      }
    } else {
      // 既没有答案也没有ID，显示错误
      messages.value.push({
        type: 'ai',
        content: '抱歉，未找到答案。',
        time: '刚刚'
      })
      scrollToBottom()
    }
  }
}


const scrollToBottom = () => {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
  })
}

const scrollToChatView = () => {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
  })
}

const handleSendMessage = async (userMessage) => {
  console.log('=== 用户发送消息 ===', userMessage)
  
  // 确保对话区域可见
  scrollToChatView()
  
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
      const response = await chatAPI.sendMessage(chatHistory)
      
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
                  const retryResponse = await fetch('/api/apps/cbit-official/chat/completions', {
                    method: 'POST',
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer app_WZCqYKovpijz2CO4T5RyiOkuAsP5qlKe'
                    },
                    body: JSON.stringify({
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
                  })
                  
                  const retryData = await retryResponse.json()
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
                  const confirmResponse = await fetch('/api/apps/cbit-official/chat/completions', {
                    method: 'POST',
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer app_WZCqYKovpijz2CO4T5RyiOkuAsP5qlKe'
                    },
                    body: JSON.stringify({
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
                  })
                  
                  const confirmData = await confirmResponse.json()
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

// 获取当前语言的文本
const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[locale.value]
  for (const k of keys) {
    value = value?.[k]
  }
  return value || key
})

// 初始化静态消息
onMounted(() => {
  messages.value = [
    {
      type: 'ai',
      content: 'welcomeIntro',
      time: '刚刚'
    },
    {
      type: 'ai',
      content: 'intro',
      time: '刚刚'
    },
    {
      type: 'ai',
      content: 'structure',
      time: '刚刚'
    },
    {
      type: 'ai',
      content: 'mission',
      time: '刚刚'
    },
    {
      type: 'news',
      time: '刚刚'
    },
    {
      type: 'team',
      time: '刚刚'
    },
    {
      type: 'events',
      time: '刚刚'
    },
    {
      type: 'projects',
      time: '刚刚'
    }
  ]
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

