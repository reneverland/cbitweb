<template>
  <div class="qa-suggestions bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-lg border border-gray-200 dark:border-gray-700">
    <div class="mb-3">
      <p class="text-sm text-gray-800 dark:text-gray-200 leading-relaxed flex items-center gap-2">
        <span class="text-lg">💡</span>
        <span>{{ locale === 'zh' ? '我们找到了以下相关问题，您是否想了解：' : 'We found the following related questions. Would you like to know:' }}</span>
      </p>
    </div>

    <div class="space-y-2 mb-3">
      <div 
        v-for="(qa, index) in suggestions" 
        :key="qa.id || index"
        class="suggestion-card bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-gray-700 dark:to-gray-600 rounded-lg p-3 cursor-pointer hover:shadow-md transition-all duration-300 border-2 border-transparent hover:border-primary"
        @click="selectQA(qa)"
      >
        <div class="flex items-start justify-between gap-2">
          <div class="flex-1">
            <div class="question text-sm font-medium text-gray-900 dark:text-white mb-1">
              {{ qa.question || qa.text || qa.title }}
            </div>
            <div v-if="qa.answer" class="answer-preview text-xs text-gray-600 dark:text-gray-400 line-clamp-2">
              {{ qa.answer.substring(0, 80) }}{{ qa.answer.length > 80 ? '...' : '' }}
            </div>
          </div>
          <div v-if="qa.similarity !== undefined" class="similarity text-xs font-medium text-primary whitespace-nowrap">
            {{ locale === 'zh' ? '匹配度' : 'Match' }}: {{ (qa.similarity * 100).toFixed(0) }}%
          </div>
        </div>
      </div>
    </div>

    <button 
      @click="continueWithAI"
      class="skip-button w-full py-2 px-3 bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors text-sm"
    >
      {{ locale === 'zh' ? '都不是，继续AI回答' : 'None of these, continue with AI' }}
    </button>
  </div>
</template>

<script setup>
const props = defineProps({
  suggestions: {
    type: Array,
    required: true
  },
  originalQuery: {
    type: String,
    required: true
  },
  locale: {
    type: String,
    default: 'zh'
  }
})

const emit = defineEmits(['select-qa', 'skip-suggestions'])

const selectQA = (qa) => {
  console.log('=== 用户选择QA ===', qa)
  emit('select-qa', qa)
}

const continueWithAI = () => {
  console.log('=== 用户选择继续AI回答 ===')
  emit('skip-suggestions', props.originalQuery)
}
</script>

<style scoped>
.suggestion-card {
  @apply transform hover:scale-[1.02];
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>

