<template>
  <div class="prose dark:prose-invert max-w-none">
    <p class="text-gray-800 dark:text-gray-200 leading-relaxed mb-4">
      {{ t('teamTitle') }}
    </p>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mt-6">
      <div 
        v-for="member in teamMembers" 
        :key="member.name"
        class="bg-gray-50 dark:bg-gray-700 rounded-xl p-4 hover:shadow-md transition-all duration-300"
      >
        <div class="flex flex-col items-center text-center">
          <img 
            :src="member.avatar" 
            :alt="member.name" 
            class="w-20 h-20 rounded-full object-cover mb-3 cursor-pointer hover:scale-105 transition-transform duration-300"
            @click="$emit('view-member-avatar', { avatar: member.avatar, name: member.name, nameEn: member.nameEn })"
            :title="`点击查看 ${member.name} 的照片`"
          >
          <h3 class="font-semibold text-gray-900 dark:text-white">{{ member.name }}</h3>
          <p class="text-sm text-gray-600 dark:text-gray-300 mb-1">{{ member.nameEn }}</p>
          <p class="text-xs text-primary font-medium">{{ member.title }}</p>
          <p class="text-xs text-gray-500 dark:text-gray-400 mt-2">{{ member.expertise }}</p>
          <a 
            v-if="member.email" 
            :href="`mailto:${member.email}`" 
            class="text-xs text-blue-500 hover:text-blue-600 mt-2"
          >
            {{ member.email }}
          </a>
          <div v-if="member.links" class="flex gap-2 mt-2">
            <a 
              v-if="member.links.website" 
              :href="member.links.website" 
              target="_blank"
              class="text-xs text-blue-500 hover:text-blue-600"
            >
              <i class="ri-link text-lg"></i>
            </a>
            <a 
              v-if="member.links.github" 
              :href="member.links.github" 
              target="_blank"
              class="text-xs text-blue-500 hover:text-blue-600"
            >
              <i class="ri-github-fill text-lg"></i>
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { i18n } from '../locales/index.js'

const props = defineProps({
  locale: {
    type: String,
    default: 'zh'
  }
})

defineEmits(['view-member-avatar'])

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) {
    value = value?.[k]
  }
  return value || key
})

const teamMembers = ref([
  {
    name: '赵建良',
    nameEn: 'Prof. Zhao Jianliang',
    title: '中心主任 / Director',
    expertise: '香港中文大学（深圳）校长讲座教授',
    avatar: '/sources/jianliangzhao.jpeg',
    email: 'leonzhao@cuhk.edu.cn',
    links: {
      website: 'https://myweb.cuhk.edu.cn/leonzhao'
    }
  },
  {
    name: '石仁达',
    nameEn: 'Ren Shi',
    title: 'Assistant Director 助理主任',
    expertise: '人工智能协作，多模态算法',
    avatar: '/sources/rendashi.jpeg',
    email: 'renshi@cuhk.edu.cn',
    links: {
      website: '/profile.html',
      github: 'https://github.com/reneverland/'
    }
  },
  {
    name: '徐睿沄',
    nameEn: 'Xu Ruiyun',
    title: '助理教授 / Assistant Professor',
    expertise: '金融科技，人工智能，区块链，智能医疗',
    avatar: '/sources/xuruiyun.jpeg',
    email: 'ruiyunxu@cuhk.edu.cn'
  },
  {
    name: '胡维',
    nameEn: 'Hu Wei',
    title: '助理研究员 / Assistant Researcher',
    expertise: '金融科技，众筹，移动营销，区块链',
    avatar: '/sources/huwei.jpeg',
    email: 'huwei72@126.com'
  },
  {
    name: '李立涛',
    nameEn: 'Li Litao',
    title: '研究助理 / Research Assistant',
    expertise: '应用机器学习，知识图谱，自然语言处理',
    avatar: '/sources/lilitao.jpeg',
    email: 'litaoli@link.cuhk.edu.cn'
  },
  {
    name: '刁玉钦',
    nameEn: 'Diao Yuqin',
    title: '研究助理 / Research Assistant',
    expertise: '人工智能，多智能体协同优化，运筹优化',
    avatar: '/sources/yuqin.png',
    email: 'diaoyuqin@cuhk.edu.cn',
    links: {
      website: '/yuqinprofile'
    }
  }
])
</script>

