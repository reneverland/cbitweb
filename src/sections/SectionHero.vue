<template>
  <section id="hero" ref="heroRef" class="relative min-h-screen flex items-center justify-center overflow-hidden pt-20">
    <div class="absolute inset-0 bg-gradient-to-br from-white via-brand-purple-light/30 to-blue-50/10 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900" />
    <div class="absolute inset-0 overflow-hidden">
      <div class="absolute top-20 left-10 w-72 h-72 bg-brand-purple/10 rounded-full blur-3xl animate-float" />
      <div class="absolute bottom-20 right-10 w-96 h-96 bg-brand-blue/10 rounded-full blur-3xl animate-float" style="animation-delay: 2s" />
      <div class="absolute top-1/2 left-1/3 w-64 h-64 bg-brand-purple-light/40 dark:bg-brand-purple/5 rounded-full blur-3xl animate-float" style="animation-delay: 1s" />
    </div>
    <div class="absolute inset-0 opacity-[0.03]" style="background-image: linear-gradient(#6941C6 1px, transparent 1px), linear-gradient(90deg, #6941C6 1px, transparent 1px); background-size: 60px 60px" />

    <div class="relative z-10 w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="grid lg:grid-cols-2 gap-12 lg:gap-16 items-center">
        <div ref="titleRef" class="text-center lg:text-left">
          <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 border border-brand-purple/20 mb-6">
            <i class="ri-sparkling-line text-brand-purple"></i>
            <span class="text-sm font-medium text-brand-purple-dark dark:text-brand-purple-light">{{ t('hero.badge') }}</span>
          </div>

          <h1 class="font-display text-5xl sm:text-6xl lg:text-7xl font-bold text-foreground mb-4 leading-tight">
            <span class="text-gradient">{{ t('hero.titleHighlight') }}</span>
          </h1>
          <p class="text-lg text-muted-foreground mb-8 max-w-xl mx-auto lg:mx-0 leading-relaxed">
            {{ t('hero.description') }}
          </p>

          <div class="flex flex-wrap gap-4 justify-center lg:justify-start">
            <button @click="scrollTo('#about')" class="px-6 py-3 rounded-full bg-gradient-brand text-white font-medium hover:opacity-90 shadow-glow transition-all hover:shadow-lg hover:-translate-y-0.5 flex items-center gap-2">
              {{ t('hero.learnMore') }}
              <i class="ri-arrow-right-line"></i>
            </button>
            <a href="mailto:renshi@cuhk.edu.cn" class="px-6 py-3 rounded-full border-2 border-brand-purple/30 text-foreground font-medium hover:bg-brand-purple-light/30 dark:hover:bg-brand-purple/10 transition-all flex items-center gap-2">
              <i class="ri-chat-3-line"></i>
              {{ t('hero.contactTeam') }}
            </a>
          </div>

          <div class="grid grid-cols-3 gap-6 mt-12 pt-8 border-t border-gray-200 dark:border-gray-700">
            <div v-for="stat in stats" :key="stat.value" class="text-center lg:text-left">
              <div class="font-display text-2xl sm:text-3xl font-bold text-gradient">
                <span v-if="stat.prefix" class="text-base font-medium text-muted-foreground mr-0.5">{{ stat.prefix }}</span>{{ stat.value }}
              </div>
              <div class="text-sm text-muted-foreground">{{ stat.label }}</div>
            </div>
          </div>
        </div>

        <!-- Interactive AI Chat Panel -->
        <div ref="chatRef" class="relative" style="perspective: 1000px">
          <div class="relative bg-white/80 dark:bg-gray-800/80 backdrop-blur-xl rounded-3xl shadow-card-hover border border-white/50 dark:border-gray-700/50 overflow-hidden">
            <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200/50 dark:border-gray-700/50 bg-gradient-to-r from-brand-purple-light/30 to-blue-50/10 dark:from-brand-purple/20 dark:to-gray-800">
              <div class="flex items-center gap-3">
                <div class="relative">
                  <div class="w-10 h-10 rounded-full bg-gradient-brand flex items-center justify-center shadow-glow animate-pulse-glow">
                    <i class="ri-robot-2-line text-white text-lg"></i>
                  </div>
                  <div class="absolute -bottom-0.5 -right-0.5 w-3 h-3 bg-green-500 rounded-full border-2 border-white dark:border-gray-800" />
                </div>
                <div>
                  <h3 class="font-display font-semibold text-sm text-foreground">{{ t('hero.chatTitle') }}</h3>
                  <p class="text-xs text-muted-foreground">{{ t('hero.chatStatus') }}</p>
                </div>
              </div>
              <div class="flex gap-1.5">
                <div class="w-2.5 h-2.5 rounded-full bg-red-400/80" />
                <div class="w-2.5 h-2.5 rounded-full bg-yellow-400/80" />
                <div class="w-2.5 h-2.5 rounded-full bg-green-400/80" />
              </div>
            </div>

            <div ref="chatMessagesRef" class="p-6 space-y-4 min-h-[320px] max-h-[400px] overflow-y-auto">
              <div
                v-for="msg in chatMessages"
                :key="msg.id"
                class="flex gap-3 transition-all duration-500"
                :class="msg.visible ? 'opacity-100 translate-x-0' : 'opacity-0 translate-x-8'"
              >
                <template v-if="msg.type === 'ai'">
                  <div class="w-8 h-8 rounded-full bg-gradient-brand flex-shrink-0 flex items-center justify-center">
                    <i class="ri-robot-2-line text-white text-sm"></i>
                  </div>
                  <div class="flex-1">
                    <div class="bg-brand-purple-light/40 dark:bg-brand-purple/20 rounded-2xl rounded-tl-sm px-4 py-3">
                      <p class="text-sm text-foreground leading-relaxed">{{ msg.content }}</p>
                    </div>
                    <span class="text-xs text-muted-foreground mt-1 block">{{ t('justNow') }}</span>
                  </div>
                </template>
                <template v-else>
                  <div class="flex-1 flex justify-end">
                    <div class="bg-gradient-brand rounded-2xl rounded-tr-sm px-4 py-3 max-w-[80%]">
                      <p class="text-sm text-white leading-relaxed">{{ msg.content }}</p>
                    </div>
                  </div>
                </template>
              </div>
              <div v-if="isTyping" class="flex gap-3">
                <div class="w-8 h-8 rounded-full bg-gradient-brand flex-shrink-0 flex items-center justify-center">
                  <i class="ri-robot-2-line text-white text-sm"></i>
                </div>
                <div class="bg-brand-purple-light/40 dark:bg-brand-purple/20 rounded-2xl rounded-tl-sm px-4 py-3">
                  <div class="typing-indicator">
                    <span class="typing-dot"></span>
                    <span class="typing-dot"></span>
                    <span class="typing-dot"></span>
                  </div>
                </div>
              </div>
            </div>

            <div class="p-4 border-t border-gray-200/50 dark:border-gray-700/50 bg-gray-50/50 dark:bg-gray-900/50">
              <div class="flex gap-3">
                <input
                  v-model="userInput"
                  type="text"
                  :placeholder="t('inputPlaceholder')"
                  class="flex-1 px-4 py-3 rounded-xl bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-sm placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-brand-purple/30 transition-all"
                  @keydown.enter="sendMessage"
                  :disabled="isLoading"
                />
                <button
                  @click="sendMessage"
                  class="w-11 h-11 rounded-xl bg-gradient-brand hover:opacity-90 shadow-glow flex items-center justify-center transition-all"
                  :disabled="isLoading || !userInput.trim()"
                >
                  <i class="ri-send-plane-fill text-white"></i>
                </button>
              </div>
              <div class="flex gap-2 mt-3">
                <button
                  v-for="q in quickQuestions"
                  :key="q"
                  @click="sendQuickQuestion(q)"
                  class="px-3 py-1.5 text-xs font-medium text-brand-purple bg-brand-purple-light/50 dark:bg-brand-purple/20 rounded-full hover:bg-brand-purple-light dark:hover:bg-brand-purple/30 transition-colors"
                >
                  {{ q }}
                </button>
              </div>
            </div>
          </div>
          <div class="absolute -top-4 -right-4 w-20 h-20 bg-brand-purple/20 rounded-full blur-2xl" />
          <div class="absolute -bottom-4 -left-4 w-24 h-24 bg-brand-blue/20 rounded-full blur-2xl" />
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted, nextTick, watch } from 'vue'
import { gsap } from 'gsap'
import { i18n } from '../locales/index.js'
import { chatAPI } from '../services/api.js'

const props = defineProps({
  locale: { type: String, default: 'en' },
  isDark: Boolean,
})

const heroRef = ref(null)
const titleRef = ref(null)
const chatRef = ref(null)
const chatMessagesRef = ref(null)
const userInput = ref('')
const isLoading = ref(false)
const isTyping = ref(false)

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) { value = value?.[k] }
  return value || key
})

const stats = computed(() => [
  { prefix: props.locale === 'zh' ? '培养' : '', value: '30+', label: props.locale === 'zh' ? '技术人员' : 'Trained Technicians' },
  { prefix: '', value: '10+', label: props.locale === 'zh' ? '落地项目' : 'Deployed Projects' },
  { prefix: '', value: '50+', label: props.locale === 'zh' ? '科研项目' : 'Research Projects' },
])

const quickQuestions = computed(() => [
  t.value('quickQuestions.research'),
  t.value('quickQuestions.cooperation'),
  t.value('quickQuestions.contact'),
])

let msgIdCounter = 4
const chatMessages = ref([
  { id: 1, type: 'ai', content: '', visible: false, isWelcome: true },
  { id: 2, type: 'ai', content: '', visible: false, isWelcome: true },
  { id: 3, type: 'ai', content: '', visible: false, isWelcome: true },
])

const updateWelcomeMessages = () => {
  chatMessages.value[0].content = t.value('hero.chatWelcome')
  chatMessages.value[1].content = t.value('hero.chatIntro')
  chatMessages.value[2].content = t.value('hero.chatChainIntel')
}

watch(() => props.locale, updateWelcomeMessages, { immediate: true })

const scrollChatToBottom = () => {
  nextTick(() => {
    if (chatMessagesRef.value) {
      chatMessagesRef.value.scrollTop = chatMessagesRef.value.scrollHeight
    }
  })
}

const scrollTo = (selector) => {
  const el = document.querySelector(selector)
  if (el) el.scrollIntoView({ behavior: 'smooth' })
}

const sendMessage = async () => {
  const text = userInput.value.trim()
  if (!text || isLoading.value) return

  chatMessages.value.push({ id: msgIdCounter++, type: 'user', content: text, visible: true })
  userInput.value = ''
  scrollChatToBottom()

  isLoading.value = true
  isTyping.value = true
  scrollChatToBottom()

  try {
    const history = chatMessages.value
      .filter(m => m.visible && m.type !== 'system' && !m.isWelcome)
      .filter(m => {
        if (m.type === 'ai') {
          const c = m.content || ''
          if (c.includes('根据知识库内容') && c.length < 50) return false
        }
        return true
      })
      .slice(-10)
      .map(m => ({ role: m.type === 'user' ? 'user' : 'assistant', content: m.content }))

    const response = await chatAPI.sendMessage(history)
    isTyping.value = false

    const fallbackZh = '感谢您的提问！我是 CBIT 链智科技研究中心的 AI 助手。您可以问我关于研究方向、合作机会、联系方式等问题，或者浏览页面了解更多。'
    const fallbackEn = 'Thanks for your question! I\'m CBIT\'s AI assistant. You can ask me about research areas, collaboration opportunities, contact info, or browse the page to learn more.'
    let aiResponse = props.locale === 'zh' ? fallbackZh : fallbackEn

    if (response.choices?.[0]) {
      const firstChoice = response.choices[0]
      const content = firstChoice.message?.content?.trim() || ''

      if (firstChoice.message?.metadata?.needs_confirmation) {
        const suggestedQuestions = response.cbit_metadata?.suggested_questions || []
        const SIMILARITY_THRESHOLD = 0.75
        const best = suggestedQuestions[0]

        if (best && best.similarity >= SIMILARITY_THRESHOLD) {
          try {
            const confirmData = await chatAPI.sendCustomRequest({
              messages: [{ role: 'user', content: text }],
              inputs: {}, response_mode: 'blocking', conversation_id: '', user: 'web-user', files: [], selected_qa_id: best.qa_id
            })
            const answer = confirmData.choices?.[0]?.message?.content?.trim()
            if (answer) aiResponse = answer
          } catch { /* keep fallback */ }
        }
      } else if (content) {
        const isIncomplete = content.includes('根据知识库内容') && content.length < 50
        if (!isIncomplete) {
          aiResponse = content
        }
      }
    } else if (response.answer?.trim()) {
      aiResponse = response.answer
    } else if (typeof response.message === 'string' && response.message.trim()) {
      aiResponse = response.message
    }

    chatMessages.value.push({ id: msgIdCounter++, type: 'ai', content: aiResponse, visible: true })
    scrollChatToBottom()
  } catch (error) {
    isTyping.value = false
    let errorMsg = props.locale === 'zh' ? '抱歉，连接服务器时出现问题，请稍后再试。' : 'Sorry, there was an issue connecting to the server. Please try again later.'
    if (error.response?.data?.detail) {
      if (Array.isArray(error.response.data.detail)) {
        const details = error.response.data.detail.map(d => d.msg || d.message || JSON.stringify(d)).join('; ')
        errorMsg = `API Error: ${details}`
      }
    }
    chatMessages.value.push({ id: msgIdCounter++, type: 'ai', visible: true, content: errorMsg })
    scrollChatToBottom()
  } finally {
    isLoading.value = false
  }
}

const sendQuickQuestion = (question) => {
  userInput.value = question
  sendMessage()
}

onMounted(() => {
  gsap.fromTo(titleRef.value, { opacity: 0, y: 60 }, { opacity: 1, y: 0, duration: 1, ease: 'expo.out', delay: 0.2 })
  gsap.fromTo(chatRef.value, { opacity: 0, rotateX: 25, y: 80 }, { opacity: 1, rotateX: 0, y: 0, duration: 1.2, ease: 'expo.out', delay: 0.4 })

  const welcomeMsgs = [chatMessages.value[0], chatMessages.value[1], chatMessages.value[2]]
  const delays = [800, 1800, 2800]
  welcomeMsgs.forEach((msg, i) => {
    setTimeout(() => {
      isTyping.value = true
      setTimeout(() => {
        msg.visible = true
        isTyping.value = i < 2
        scrollChatToBottom()
      }, 600)
    }, delays[i])
  })
})
</script>
