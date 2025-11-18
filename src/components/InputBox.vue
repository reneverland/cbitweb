<template>
  <div class="input-box-container" :class="{ 'profile-page': isProfilePage }">
    <div class="input-box-inner" :class="{ 'profile-page': isProfilePage }">
      <div class="flex items-center gap-3">
        <button 
          @click="clearChat"
          class="w-9 h-9 flex items-center justify-center rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors group"
          title="清除对话"
        >
          <i class="ri-delete-bin-line text-gray-400 group-hover:text-red-500 text-lg transition-colors"></i>
        </button>
        <input 
          ref="inputRef"
          v-model="inputMessage"
          @keyup.enter="sendMessage"
          type="text"
          :placeholder="inputPlaceholder || t('inputPlaceholder')"
          class="flex-1 bg-transparent border-none outline-none text-gray-800 dark:text-gray-200 placeholder-gray-500 text-sm"
          :disabled="isLoading"
        >
        <div class="flex items-center gap-2">
          <button 
            v-for="question in (quickQuestions.length > 0 ? quickQuestions : defaultQuickQuestions)" 
            :key="question"
            @click="sendQuickQuestion(question)"
            class="quick-question px-3 py-1 text-xs bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-full hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors whitespace-nowrap !rounded-button"
            :disabled="isLoading"
          >
            {{ question }}
          </button>
          <button 
            @click="sendMessage"
            class="w-10 h-10 bg-primary rounded-full flex items-center justify-center hover:bg-secondary transition-colors !rounded-button"
            :disabled="isLoading || !inputMessage.trim()"
          >
            <i class="ri-send-plane-line text-white text-lg"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { i18n } from '../locales/index.js'

const props = defineProps({
  isLoading: {
    type: Boolean,
    default: false
  },
  locale: {
    type: String,
    default: 'zh'
  },
  inputPlaceholder: {
    type: String,
    default: ''
  },
  quickQuestions: {
    type: Array,
    default: () => []
  },
  isProfilePage: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['send-message', 'clear-chat'])

const inputMessage = ref('')
const inputRef = ref(null)

// 调试：输出 isProfilePage 的值
onMounted(() => {
  console.log('InputBox - isProfilePage:', props.isProfilePage)
  console.log('InputBox - profile-page class should be:', props.isProfilePage ? 'applied' : 'NOT applied')
})

const clearChat = () => {
  emit('clear-chat')
}

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) {
    value = value?.[k]
  }
  return value || key
})

const defaultQuickQuestions = computed(() => [
  t.value('quickQuestions.research'),
  t.value('quickQuestions.cooperation'),
  t.value('quickQuestions.contact')
])

const sendMessage = () => {
  if (inputMessage.value.trim() && !props.isLoading) {
    emit('send-message', inputMessage.value.trim())
    inputMessage.value = ''
  }
}

const sendQuickQuestion = (question) => {
  if (!props.isLoading) {
    emit('send-message', question)
  }
}
</script>

<style scoped>
.input-box-container {
  position: fixed;
  bottom: 1.5rem;
  left: 50%;
  transform: translateX(-50%);
  transform-origin: center bottom;
  width: 100%;
  max-width: 50rem;
  padding: 0 1.5rem;
  z-index: 9999;
}

.input-box-inner {
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 2px solid rgba(209, 213, 219, 0.4);
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
  border-radius: 1rem;
  padding: 1rem;
  transition: all 0.3s ease;
}

.dark .input-box-inner {
  background: rgba(31, 41, 55, 0.8);
  border-color: rgba(75, 85, 99, 0.4);
}

.input-box-container:hover .input-box-inner {
  background: rgba(255, 255, 255, 0.85);
}

.dark .input-box-container:hover .input-box-inner {
  background: rgba(31, 41, 55, 0.9);
}

.input-box-container:hover {
  transform: translateX(-50%) translateY(-2px);
}

/* Profile 页面特殊样式 - 融入背景 */
.input-box-container.profile-page {
  z-index: 5 !important;
}

.input-box-container.profile-page .input-box-inner {
  background: rgba(249, 250, 251, 0.08) !important;
  backdrop-filter: blur(20px) !important;
  -webkit-backdrop-filter: blur(20px) !important;
  border: 1px solid rgba(209, 213, 219, 0.1) !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03) !important;
}

/* Dark mode 样式 - 使用多种选择器确保匹配 */
:global(.dark) .input-box-container.profile-page .input-box-inner,
:global(body:has(.dark)) .input-box-container.profile-page .input-box-inner,
.input-box-container.profile-page .input-box-inner:global(.dark) {
  background: rgba(17, 24, 39, 0.08) !important;
  border-color: rgba(75, 85, 99, 0.1) !important;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2) !important;
}

.input-box-container.profile-page:hover .input-box-inner {
  background: rgba(249, 250, 251, 0.15) !important;
  border-color: rgba(209, 213, 219, 0.2) !important;
}

:global(.dark) .input-box-container.profile-page:hover .input-box-inner,
:global(body:has(.dark)) .input-box-container.profile-page:hover .input-box-inner {
  background: rgba(17, 24, 39, 0.15) !important;
  border-color: rgba(75, 85, 99, 0.2) !important;
}

/* 添加动画 */
@keyframes fade-in {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

:global(.animate-fade-in) {
  animation: fade-in 0.3s ease-out;
}
</style>

