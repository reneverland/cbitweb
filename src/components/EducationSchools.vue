<template>
  <div class="education-schools">
    <h3 class="text-base font-semibold text-gray-900 dark:text-white mb-3">
      {{ locale === 'zh' ? '教育背景' : 'Education Background' }}
    </h3>
    <div class="bg-white dark:bg-gray-700 rounded-xl p-4 border border-gray-200 dark:border-gray-600">
      <ul class="space-y-2">
        <li 
          v-for="(school, index) in schools" 
          :key="index"
          class="text-sm text-gray-800 dark:text-gray-200 leading-relaxed"
        >
          <span class="font-medium">{{ school.display }}</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  locale: {
    type: String,
    default: 'zh'
  }
})

const schools = ref([
  {
    display: 'Duke University MMS'
  },
  {
    display: 'North Carolina State University FM/CS'
  }
])
</script>

<style scoped>
/* 简洁的教育背景样式 */
</style>

