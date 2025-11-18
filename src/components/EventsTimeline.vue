<template>
  <div class="prose dark:prose-invert max-w-none">
    <div class="flex items-center justify-between mb-4">
      <div class="flex-1">
        <p class="text-gray-800 dark:text-gray-200 leading-relaxed mb-2 font-semibold">
          {{ t('eventsTitle') }}
        </p>
        <p class="text-gray-600 dark:text-gray-300 text-sm">
          {{ t('eventsSubtitle') }}
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
    
    <!-- 预览模式：显示最新2个 -->
    <div v-if="!isExpanded" class="space-y-4">
      <div 
        v-for="(event, index) in events.slice(0, 2)" 
        :key="index"
        class="border-l-4 pl-4 py-2 bg-gradient-to-r from-purple-50 to-pink-50 dark:from-gray-800 dark:to-gray-700 rounded-r-lg"
        :class="index % 2 === 0 ? 'border-purple-500' : 'border-pink-500'"
      >
        <div class="flex items-center gap-2 mb-2">
          <i 
            class="text-lg"
            :class="[
              'ri-calendar-event-line',
              index % 2 === 0 ? 'text-purple-500' : 'text-pink-500'
            ]"
          ></i>
          <span class="text-sm font-medium text-gray-900 dark:text-white">{{ event.title }}</span>
        </div>
        <p class="text-sm text-gray-600 dark:text-gray-300 mb-2">{{ event.date }}</p>
        <div class="text-xs text-gray-500 dark:text-gray-400 space-y-1">
          <p v-for="(organizer, idx) in event.organizers" :key="idx">{{ organizer }}</p>
          <a 
            v-if="event.link" 
            :href="event.link" 
            target="_blank"
            class="text-blue-500 hover:text-blue-600 inline-flex items-center gap-1 mt-2 group"
          >
            {{ event.linkText }}
            <i class="ri-external-link-line group-hover:translate-x-0.5 transition-transform"></i>
          </a>
        </div>
      </div>
    </div>

    <!-- 展开模式：显示所有 -->
    <div v-else class="space-y-4 animate-fade-in">
      <div 
        v-for="(event, index) in events" 
        :key="index"
        class="border-l-4 pl-4 py-2 bg-gradient-to-r from-purple-50 to-pink-50 dark:from-gray-800 dark:to-gray-700 rounded-r-lg hover:shadow-md transition-all duration-300"
        :class="index % 2 === 0 ? 'border-purple-500' : 'border-pink-500'"
      >
        <div class="flex items-center gap-2 mb-2">
          <i 
            class="text-lg"
            :class="[
              'ri-calendar-event-line',
              index % 2 === 0 ? 'text-purple-500' : 'text-pink-500'
            ]"
          ></i>
          <span class="text-sm font-medium text-gray-900 dark:text-white">{{ event.title }}</span>
        </div>
        <p class="text-sm text-gray-600 dark:text-gray-300 mb-2">{{ event.date }}</p>
        <div class="text-xs text-gray-500 dark:text-gray-400 space-y-1">
          <p v-for="(organizer, idx) in event.organizers" :key="idx">{{ organizer }}</p>
          <a 
            v-if="event.link" 
            :href="event.link" 
            target="_blank"
            class="text-blue-500 hover:text-blue-600 inline-flex items-center gap-1 mt-2 group"
          >
            {{ event.linkText }}
            <i class="ri-external-link-line group-hover:translate-x-0.5 transition-transform"></i>
          </a>
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

const isExpanded = ref(false)

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) {
    value = value?.[k]
  }
  return value || key
})

const events = ref([
  {
    title: 'ICSF2025 Shanghai',
    date: 'July 1-2, 2025',
    organizers: [
      'School of Economics and Management, Tongji University',
      'Shenzhen Institute of Economics and Management, Tsinghua University',
      'Institute of Innovation Management, Tsinghua Shenzhen International Graduate School'
    ],
    link: 'https://sem.tongji.edu.cn/ICSF2025/',
    linkText: 'ICSF 2025 Conference Link'
  },
  {
    title: 'ICSF2024 Anhui',
    date: 'July 27-28, 2024',
    organizers: [
      'Faculty of Business in SciTech & School of Management & International Institute of Finance',
      'University of Science and Technology of China',
      'Anhui, China'
    ],
    link: '/sources/ICSF/ICSF24/index.html',
    linkText: 'ICSF 2024 Conference Link'
  },
  {
    title: 'ICSF2023 Dubai',
    date: 'August 4-6, 2023',
    organizers: [
      'Faculty of Business',
      'University of Wollongong in Dubai',
      'Dubai, United Arab Emirates'
    ],
    link: '/sources/ICSF/ICSF23/index.html',
    linkText: 'ICSF 2023 Conference Link'
  },
  {
    title: 'ICSF2022 Hong Kong',
    date: 'August 19-20, 2022',
    organizers: [
      'Faculty of Business and Economics',
      'The University of Hong Kong',
      'Hong Kong'
    ],
    link: '/sources/ICSF/ICSF22/index.html',
    linkText: 'ICSF 2022 Conference Link'
  },
  {
    title: 'ICSF2021 Shenzhen',
    date: 'August 20-21, 2021',
    organizers: [
      'School of Management and Economics',
      'The Chinese University of Hong Kong, Shenzhen',
      'Shenzhen, China'
    ],
    link: '/sources/ICSF/ICSF21/index.html',
    linkText: 'ICSF 2021 Conference Link'
  },
  {
    title: 'ICSF2020 Beijing',
    date: 'August 20-22, 2020',
    organizers: [
      'College of Economics and Management at the Beijing University of Technology',
      'School of Belt and Road at University of Chinese Academy of Sciences',
      'Center on Global Internet Finance at the City University of Hong Kong'
    ],
    link: '/sources/ICSF/ICSF20/index.html',
    linkText: 'ICSF 2020 Conference Link'
  },
  {
    title: 'ICSF2019 Beijing',
    date: 'July 26-28, 2019',
    organizers: [
      'Beijing University of Technology',
      'University of Chinese Academy of Sciences',
      'Beijing, China'
    ],
    link: '/sources/ICSF/ICSF19/index.html',
    linkText: 'ICSF 2019 Conference Link'
  },
  {
    title: 'ICSF2018 Shenzhen',
    date: 'July 07-08, 2018',
    organizers: [
      'South University of Science and Technology',
      'Shenzhen, China'
    ],
    link: '/sources/ICSF/ICSF18/index.html',
    linkText: 'ICSF 2018 Conference Link'
  },
  {
    title: 'ICSF2017 Guangzhou',
    date: 'July 16-17, 2017',
    organizers: [
      'Sun Yat-sen University',
      'Guangzhou, China'
    ],
    link: '/sources/ICSF/ICSF17/index.html',
    linkText: 'ICSF 2017 Conference Link'
  },
  {
    title: 'ICSF2016 Shenzhen',
    date: 'May 20-21, 2016',
    organizers: [
      'Center on Global Internet Finance at the City University of Hong Kong',
      'Shenzhen Research Institute, Shenzhen, China'
    ],
    link: '/sources/ICSF/ICSF16/index.html',
    linkText: 'ICSF 2016 Conference Link'
  }
])
</script>
