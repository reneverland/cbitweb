<template>
  <!-- AI 消息气泡 -->
  <div v-if="message.type === 'ai'" class="chat-bubble bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-lg border border-gray-200 dark:border-gray-700">
    <div class="flex items-start gap-4">
      <!-- Profile页面使用个人头像，主页使用机器人图标 -->
      <img 
        v-if="isProfilePage" 
        src="/sources/rendashi.jpeg" 
        alt="Ren" 
        class="w-14 h-14 rounded-xl object-cover flex-shrink-0 shadow-md cursor-pointer hover:scale-105 transition-transform duration-300"
        @click="$emit('view-avatar')"
        title="点击查看大图"
      >
      <div v-else class="w-10 h-10 bg-gradient-to-br from-primary to-secondary rounded-full flex items-center justify-center flex-shrink-0">
        <i class="ri-robot-2-line text-white text-lg"></i>
      </div>
      <div class="flex-1">
        <div class="mb-2">
          <span class="text-sm font-medium text-gray-900 dark:text-white">{{ isProfilePage ? t('profile.aiName') : t('aiName') }}</span>
          <span class="text-xs text-gray-500 ml-2">{{ t('justNow') }}</span>
        </div>
        <div v-if="message.content === 'typing'" class="typing-indicator">
          <div class="typing-dot"></div>
          <div class="typing-dot"></div>
          <div class="typing-dot"></div>
        </div>
        <div v-else class="prose dark:prose-invert max-w-none">
          <p class="text-sm text-gray-800 dark:text-gray-200 leading-relaxed whitespace-pre-line" v-html="formatContent(getMessageContent(message.content))"></p>
        </div>
      </div>
    </div>
  </div>

  <!-- 用户消息气泡 -->
  <div v-else-if="message.type === 'user'" class="chat-bubble bg-primary text-white rounded-2xl p-6 shadow-lg">
    <div class="flex items-start gap-4 justify-end">
      <div class="flex-1 text-right">
        <div class="mb-2">
          <span class="text-sm font-medium">{{ t('you') }}</span>
          <span class="text-xs opacity-75 ml-2">{{ t('justNow') }}</span>
        </div>
        <p class="text-sm leading-relaxed">{{ message.content }}</p>
      </div>
      <div class="w-10 h-10 bg-white bg-opacity-20 rounded-full flex items-center justify-center flex-shrink-0">
        <i class="ri-user-line text-white text-lg"></i>
      </div>
    </div>
  </div>

  <!-- 团队成员展示 -->
  <div v-else-if="message.type === 'team'" class="chat-bubble bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-lg border border-gray-200 dark:border-gray-700">
    <div class="flex items-start gap-4">
      <div class="w-10 h-10 bg-gradient-to-br from-primary to-secondary rounded-full flex items-center justify-center flex-shrink-0">
        <i class="ri-robot-2-line text-white text-lg"></i>
      </div>
      <div class="flex-1">
        <div class="mb-2">
          <span class="text-sm font-medium text-gray-900 dark:text-white">{{ t('aiName') }}</span>
          <span class="text-xs text-gray-500 ml-2">{{ t('justNow') }}</span>
        </div>
        <TeamMember :locale="locale" @view-member-avatar="$emit('view-member-avatar', $event)" />
      </div>
    </div>
  </div>

  <!-- 会议活动展示 -->
  <div v-else-if="message.type === 'events'" class="chat-bubble bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-lg border border-gray-200 dark:border-gray-700">
    <div class="flex items-start gap-4">
      <div class="w-10 h-10 bg-gradient-to-br from-primary to-secondary rounded-full flex items-center justify-center flex-shrink-0">
        <i class="ri-robot-2-line text-white text-lg"></i>
      </div>
      <div class="flex-1">
        <div class="mb-2">
          <span class="text-sm font-medium text-gray-900 dark:text-white">{{ t('aiName') }}</span>
          <span class="text-xs text-gray-500 ml-2">{{ t('justNow') }}</span>
        </div>
        <EventsTimeline :locale="locale" />
      </div>
    </div>
  </div>

  <!-- 项目分类展示 -->
  <div v-else-if="message.type === 'projects'">
    <CenterProjects :locale="locale" />
  </div>

  <!-- 个人AI项目展示 -->
  <div v-else-if="message.type === 'profile-projects'" class="chat-bubble bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-lg border border-gray-200 dark:border-gray-700">
    <div class="flex items-start gap-4">
      <img 
        src="/sources/rendashi.jpeg" 
        alt="Ren" 
        class="w-14 h-14 rounded-xl object-cover flex-shrink-0 shadow-md cursor-pointer hover:scale-105 transition-transform duration-300"
        @click="$emit('view-avatar')"
        title="点击查看大图"
      >
      <div class="flex-1">
        <div class="mb-2">
          <span class="text-sm font-medium text-gray-900 dark:text-white">{{ t('profile.aiName') }}</span>
          <span class="text-xs text-gray-500 ml-2">{{ t('justNow') }}</span>
        </div>
        <ProjectsCard :locale="locale" />
      </div>
    </div>
  </div>

  <!-- 个人教育背景展示 -->
  <div v-else-if="message.type === 'education-schools'" class="chat-bubble bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-lg border border-gray-200 dark:border-gray-700">
    <div class="flex items-start gap-4">
      <img 
        src="/sources/rendashi.jpeg" 
        alt="Ren" 
        class="w-14 h-14 rounded-xl object-cover flex-shrink-0 shadow-md cursor-pointer hover:scale-105 transition-transform duration-300"
        @click="$emit('view-avatar')"
        title="点击查看大图"
      >
      <div class="flex-1">
        <div class="mb-2">
          <span class="text-sm font-medium text-gray-900 dark:text-white">{{ t('profile.aiName') }}</span>
          <span class="text-xs text-gray-500 ml-2">{{ t('justNow') }}</span>
        </div>
        <EducationSchools :locale="locale" />
      </div>
    </div>
  </div>

  <!-- 中心动态展示 -->
  <div v-else-if="message.type === 'news'" class="chat-bubble bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-lg border border-gray-200 dark:border-gray-700">
    <div class="flex items-start gap-4">
      <div class="w-10 h-10 bg-gradient-to-br from-primary to-secondary rounded-full flex items-center justify-center flex-shrink-0">
        <i class="ri-robot-2-line text-white text-lg"></i>
      </div>
      <div class="flex-1">
        <div class="mb-2">
          <span class="text-sm font-medium text-gray-900 dark:text-white">{{ t('aiName') }}</span>
          <span class="text-xs text-gray-500 ml-2">{{ t('justNow') }}</span>
        </div>
        <CenterNews :locale="locale" />
      </div>
    </div>
  </div>

</template>

<script setup>
import { computed } from 'vue'
import TeamMember from './TeamMember.vue'
import EventsTimeline from './EventsTimeline.vue'
import CenterProjects from './CenterProjects.vue'
import CenterNews from './CenterNews.vue'
import ProjectsCard from './ProjectsCard.vue'
import EducationSchools from './EducationSchools.vue'
import { i18n } from '../locales/index.js'

const props = defineProps({
  message: {
    type: Object,
    required: true
  },
  locale: {
    type: String,
    default: 'zh'
  },
  isProfilePage: {
    type: Boolean,
    default: false
  }
})

defineEmits(['select-qa', 'view-avatar', 'view-member-avatar'])

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) {
    value = value?.[k]
  }
  return value || key
})

const getMessageContent = (content) => {
  // 如果content是i18n的key，从i18n获取（支持嵌套key如 profile.welcomeIntro）
  const keys = content.split('.')
  let value = i18n[props.locale]
  
  for (const k of keys) {
    if (value && typeof value === 'object' && k in value) {
      value = value[k]
    } else {
      // 如果找不到嵌套key，直接返回内容（用户消息或AI回复）
  return content
    }
  }
  
  // 如果找到了有效的翻译文本，返回它
  return typeof value === 'string' ? value : content
}

const formatContent = (content) => {
  // 支持markdown粗体和链接
  return content
    .replace(/\[([^\]]+)\]\(([^)]+)\)/g, (match, text, url) => {
      // 判断是否为外部链接
      const isExternal = url.startsWith('http://') || url.startsWith('https://')
      const target = isExternal ? ' target="_blank"' : ''
      return `<a href="${url}" class="text-blue-500 hover:text-blue-600 dark:text-blue-400 dark:hover:text-blue-300 underline"${target}>${text}</a>`
    })
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\n/g, '<br>')
}
</script>

