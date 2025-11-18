<template>
  <div class="projects-card">
    <div class="mb-4">
      <p class="text-sm font-semibold text-gray-800 dark:text-gray-200">
        {{ locale === 'zh' ? '主导项目' : 'Led Projects' }}
      </p>
      <p class="text-xs text-gray-600 dark:text-gray-400 mt-1">
        {{ locale === 'zh' ? '以下是我主导和参与的 AI 项目，所有项目均已上线并处于测试阶段' : 'Here are the AI projects I have led and participated in. All projects are now online and in the testing phase' }}
      </p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <component 
        :is="project.link ? 'a' : 'div'"
        v-for="(project, index) in projects" 
        :key="index"
        :href="project.link"
        :target="project.link ? '_blank' : undefined"
        class="project-card bg-gradient-to-br from-white to-gray-50 dark:from-gray-700 dark:to-gray-600 rounded-xl p-4 border-2 border-gray-200 dark:border-gray-600 hover:border-primary dark:hover:border-primary transition-all duration-300 hover:shadow-lg transform hover:-translate-y-1"
      >
        <div class="flex items-start gap-3">
          <div class="w-10 h-10 rounded-lg bg-gradient-to-br from-primary to-secondary flex items-center justify-center flex-shrink-0 text-white font-bold text-lg">
            {{ project.icon }}
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1">
              <h3 class="text-sm font-semibold text-gray-900 dark:text-white break-words">
                {{ locale === 'zh' ? project.name : project.nameEn }}
              </h3>
              <i v-if="project.link" class="ri-external-link-line text-xs text-primary"></i>
              <span v-if="project.status" class="text-xs px-2 py-0.5 bg-yellow-100 dark:bg-yellow-900 text-yellow-800 dark:text-yellow-200 rounded-full">
                {{ project.status }}
              </span>
            </div>
            <p class="text-xs text-gray-600 dark:text-gray-400 break-words">
              {{ locale === 'zh' ? project.description : project.descriptionEn }}
            </p>
          </div>
        </div>
      </component>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  locale: {
    type: String,
    default: 'zh'
  }
})

const projects = computed(() => [
  {
    icon: 'A',
    name: 'AiExam-plus AI智能考核平台',
    nameEn: 'AiExam-plus AI Assessment Platform',
    description: '智能化考核与评估系统',
    descriptionEn: 'Intelligent assessment and evaluation system',
    link: 'http://www.llmhi.com:9000'
  },
  {
    icon: '电',
    name: '中电一所AI电子档案管理',
    nameEn: 'CETC AI Archive Management',
    description: '驻点项目 - AI智能档案管理系统',
    descriptionEn: 'On-site project - AI intelligent archive management system',
    status: '驻点'
  },
  {
    icon: '港',
    name: '香港中文大学(深圳) AI智能助手',
    nameEn: 'CUHK-Shenzhen AI Assistant',
    description: '校园智能问答助手',
    descriptionEn: 'Campus intelligent Q&A assistant',
    link: 'http://www.llmhi.com:9200'
  },
  {
    icon: 'G',
    name: '广东以色列理工学院 AI智能助手',
    nameEn: 'GTIIT AI Smart Assistant',
    description: '为广东以色列理工学院提供的智能问答助手',
    descriptionEn: 'Intelligent Q&A assistant for GTIIT',
    link: 'http://www.llmhi.com:9400'
  },
  {
    icon: 'V',
    name: 'VoxChina 生成式科研平台',
    nameEn: 'VoxChina Generative Research Platform',
    description: '生成式AI科研协作平台',
    descriptionEn: 'Generative AI research collaboration platform',
    status: '开发中'
  },
  {
    icon: '江',
    name: '江招智能招标审核系统',
    nameEn: 'JiangZhao Smart Bidding Review System',
    description: 'AI驱动的智能招标审核与管理系统',
    descriptionEn: 'AI-driven intelligent bidding review and management system',
    status: '开发中'
  },
  {
    icon: '学',
    name: '深圳学徒平台',
    nameEn: 'Shenzhen Apprentice Platform',
    description: '深圳学徒培养与管理平台',
    descriptionEn: 'Shenzhen apprentice training and management platform'
  },
  {
    icon: 'C',
    name: 'CBIT×百度真人生成模型',
    nameEn: 'CBIT×Baidu Real Person Generation',
    description: 'CBIT与百度深圳Design Team合作的真人生成模型',
    descriptionEn: 'Real person generation model with Baidu Shenzhen Design Team',
    link: 'http://airesearchgpt.com:9500/login'
  },
  {
    icon: '联',
    name: 'CBIT即时联网大模型 3.3',
    nameEn: 'CBIT Real-time Internet LLM 3.3',
    description: '具备实时联网能力的大语言模型',
    descriptionEn: 'Large language model with real-time internet connectivity'
  },
  {
    icon: 'I',
    name: 'IMBA小程序',
    nameEn: 'IMBA Mini Program',
    description: 'IMBA项目专属小程序应用',
    descriptionEn: 'Dedicated mini program for IMBA project'
  }
])
</script>

<style scoped>
.project-card {
  @apply cursor-pointer;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>

