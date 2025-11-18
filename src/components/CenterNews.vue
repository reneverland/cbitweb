<template>
  <div class="prose dark:prose-invert max-w-none">
    <div class="flex items-center justify-between mb-4">
      <div class="flex-1">
        <p class="text-gray-800 dark:text-gray-200 leading-relaxed mb-2 font-semibold">
          {{ locale === 'zh' ? '中心动态' : 'Center News' }}
        </p>
        <p class="text-gray-600 dark:text-gray-300 text-sm">
          {{ locale === 'zh' ? '最新研究成果与中心活动' : 'Latest Research Achievements and Center Activities' }}
        </p>
      </div>
      <button 
        @click="isExpanded = !isExpanded"
        class="ml-4 flex-shrink-0 w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-all duration-300 group"
        :title="isExpanded ? (locale === 'zh' ? '收起' : 'Collapse') : (locale === 'zh' ? '展开全部' : 'Show All')"
      >
        <i :class="isExpanded ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'" class="text-xl text-gray-600 dark:text-gray-300 group-hover:text-primary transition-colors"></i>
      </button>
    </div>
    
    <!-- 预览模式：显示最新1条 -->
    <div v-if="!isExpanded" class="space-y-4">
      <article class="bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-700 rounded-2xl p-6 border border-blue-100 dark:border-gray-600 hover:shadow-lg transition-all duration-300">
        <div class="flex items-start gap-4">
          <div class="flex-shrink-0">
            <div class="w-12 h-12 rounded-full bg-gradient-to-br from-blue-500 to-indigo-500 flex items-center justify-center">
              <i class="ri-newspaper-line text-white text-xl"></i>
            </div>
          </div>
          <div class="flex-1">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-2">
              {{ locale === 'zh' ? '研究 | 从"技术冰河"到"黄金时代"，赵建良教授发文解码生成式AI的范式迭代' : 'Research | From "Tech Winter" to "Golden Age": Prof. Zhao Decodes Generative AI Paradigm Shifts' }}
            </h3>
            <p class="text-sm text-gray-500 dark:text-gray-400 mb-3 flex items-center gap-2">
              <i class="ri-calendar-line"></i>
              March 28th, 2025
            </p>
            <p class="text-sm text-gray-700 dark:text-gray-300 mb-4 line-clamp-2">
              {{ locale === 'zh' ? '港中大（深圳）经管学院赵建良教授的合作研究在国际信息系统前沿期刊《Information Systems Frontiers》线上发表' : 'Prof. Zhao Jianliang\'s collaborative research published online in Information Systems Frontiers' }}
            </p>
            <a 
              href="#" 
              class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-300 text-sm font-medium group"
            >
              {{ locale === 'zh' ? '阅读更多' : 'Read more' }}
              <i class="ri-arrow-right-line group-hover:translate-x-1 transition-transform"></i>
            </a>
          </div>
        </div>
      </article>
    </div>

    <!-- 展开模式：显示所有新闻 -->
    <div v-else class="space-y-4 animate-fade-in">
      <article 
        v-for="(news, index) in newsList" 
        :key="index"
        class="bg-gradient-to-br from-blue-50 to-indigo-50 dark:from-gray-800 dark:to-gray-700 rounded-2xl p-6 border border-blue-100 dark:border-gray-600 hover:shadow-lg transition-all duration-300"
      >
        <div class="flex items-start gap-4">
          <div class="flex-shrink-0">
            <div class="w-12 h-12 rounded-full bg-gradient-to-br from-blue-500 to-indigo-500 flex items-center justify-center">
              <i class="ri-newspaper-line text-white text-xl"></i>
            </div>
          </div>
          <div class="flex-1">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-2">
              {{ news.title }}
            </h3>
            <p class="text-sm text-gray-500 dark:text-gray-400 mb-3 flex items-center gap-2">
              <i class="ri-calendar-line"></i>
              {{ news.date }}
            </p>
            <p class="text-sm text-gray-700 dark:text-gray-300 mb-4">
              {{ news.description }}
            </p>
            <a 
              :href="news.link" 
              target="_blank"
              class="inline-flex items-center gap-1 text-blue-600 hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-300 text-sm font-medium group"
            >
              {{ locale === 'zh' ? '阅读更多' : 'Read more' }}
              <i class="ri-arrow-right-line group-hover:translate-x-1 transition-transform"></i>
            </a>
          </div>
        </div>
      </article>
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

const isExpanded = ref(false)

const newsList = ref([
  {
    title: props.locale === 'zh' 
      ? '研究 | 从"技术冰河"到"黄金时代"，赵建良教授发文解码生成式AI的范式迭代' 
      : 'Research | From "Tech Winter" to "Golden Age": Prof. Zhao Decodes Generative AI Paradigm Shifts',
    date: 'March 28th, 2025',
    description: props.locale === 'zh'
      ? '港中大（深圳）经管学院赵建良教授的合作研究在国际信息系统前沿期刊《Information Systems Frontiers》线上发表'
      : 'Prof. Zhao Jianliang\'s collaborative research published online in Information Systems Frontiers',
    link: '#'
  }
])
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>

