<template>
  <section id="publications" ref="sectionRef" class="relative py-24 lg:py-32 overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-white via-gray-50/20 to-white dark:from-gray-900 dark:via-gray-800/20 dark:to-gray-900" />
    <div class="absolute top-0 left-0 w-1/2 h-full bg-gradient-to-r from-brand-purple-light/10 dark:from-brand-purple/5 to-transparent" />

    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex flex-col md:flex-row md:items-end md:justify-between mb-12">
        <div>
          <div class="news-title inline-flex items-center gap-2 px-4 py-2 rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 border border-brand-purple/20 mb-6">
            <i class="ri-newspaper-line text-brand-purple"></i>
            <span class="text-sm font-medium text-brand-purple-dark dark:text-brand-purple-light">{{ t('news.badge') }}</span>
          </div>
          <h2 class="news-title font-display text-4xl sm:text-5xl font-bold text-foreground mb-4">
            {{ t('news.title') }}<span class="text-gradient">{{ t('news.titleHighlight') }}</span>
          </h2>
          <p class="news-title text-lg text-muted-foreground max-w-xl">{{ t('news.subtitle') }}</p>
        </div>
        <div class="news-title flex gap-3 mt-6 md:mt-0">
          <button @click="prevSlide" class="w-10 h-10 rounded-full border border-gray-200 dark:border-gray-700 flex items-center justify-center hover:bg-brand-purple-light/50 dark:hover:bg-brand-purple/20 transition-colors">
            <i class="ri-arrow-left-s-line text-lg"></i>
          </button>
          <button @click="nextSlide" class="w-10 h-10 rounded-full border border-gray-200 dark:border-gray-700 flex items-center justify-center hover:bg-brand-purple-light/50 dark:hover:bg-brand-purple/20 transition-colors">
            <i class="ri-arrow-right-s-line text-lg"></i>
          </button>
        </div>
      </div>

      <div class="news-slider relative overflow-hidden">
        <div class="flex transition-transform duration-700 ease-out" :style="{ transform: `translateX(-${activeIndex * 100}%)` }">
          <div v-for="item in newsItems" :key="item.id" class="w-full flex-shrink-0 px-2">
            <div class="group relative rounded-3xl overflow-hidden bg-white dark:bg-gray-800 border border-gray-200/50 dark:border-gray-700/50 shadow-card hover:shadow-card-hover transition-all duration-500">
              <div class="grid lg:grid-cols-2">
                <div :class="`relative h-64 lg:h-auto min-h-[400px] bg-gradient-to-br ${item.color} p-8 flex flex-col justify-between`">
                  <div class="absolute inset-0 opacity-20" style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 32px 32px" />
                  <div class="relative z-10 flex gap-2">
                    <span v-for="(tag, idx) in item.tags" :key="idx" class="px-3 py-1 rounded-full bg-white/20 backdrop-blur-sm text-white text-sm font-medium">{{ tag }}</span>
                  </div>
                  <div class="relative z-10 text-white">
                    <div class="font-display text-4xl lg:text-5xl font-bold mb-2">{{ item.title.split(' ')[0] }}</div>
                    <div class="text-white/80 text-lg">{{ item.subtitle }}</div>
                  </div>
                </div>
                <div class="p-8 lg:p-10">
                  <h3 class="font-display text-2xl font-semibold text-foreground mb-4 group-hover:text-brand-purple transition-colors">{{ item.title }}</h3>
                  <p class="text-muted-foreground leading-relaxed mb-6">{{ item.description }}</p>
                  <div class="flex flex-wrap gap-4 mb-8">
                    <div class="flex items-center gap-2 text-sm text-muted-foreground"><i class="ri-calendar-line text-brand-purple"></i>{{ item.date }}</div>
                    <div class="flex items-center gap-2 text-sm text-muted-foreground"><i class="ri-map-pin-line text-brand-purple"></i>{{ item.location }}</div>
                  </div>
                  <div class="flex gap-3">
                    <a :href="item.link" target="_blank" class="px-5 py-2.5 rounded-full bg-gradient-brand text-white text-sm font-medium hover:opacity-90 shadow-glow flex items-center gap-2">
                      {{ t('news.readMore') }}<i class="ri-arrow-right-line"></i>
                    </a>
                    <a v-if="item.link !== '#'" :href="item.link" target="_blank" class="px-5 py-2.5 rounded-full border border-gray-200 dark:border-gray-700 text-sm font-medium hover:bg-gray-50 dark:hover:bg-gray-700 flex items-center gap-2">
                      <i class="ri-external-link-line"></i>{{ t('news.conferenceLink') }}
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="flex justify-center gap-2 mt-8">
          <button v-for="(_, index) in newsItems" :key="index" @click="activeIndex = index"
            class="h-2.5 rounded-full transition-all duration-300"
            :class="index === activeIndex ? 'w-8 bg-gradient-brand' : 'w-2.5 bg-gray-300 dark:bg-gray-600 hover:bg-gray-400'" />
        </div>
      </div>

    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { gsap } from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'
import { i18n } from '../locales/index.js'
gsap.registerPlugin(ScrollTrigger)

const props = defineProps({ locale: { type: String, default: 'en' } })
const sectionRef = ref(null)
const activeIndex = ref(0)

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) { value = value?.[k] }
  return value || key
})

const newsItems = computed(() => [
  {
    id: 1,
    title: props.locale === 'zh' ? 'ICSF2026 | 第11届国际智慧金融峰会征稿通知' : 'ICSF2026 | Call for Papers – 11th ICSF',
    subtitle: props.locale === 'zh' ? '2026年6月深圳大学' : 'June 2026, Shenzhen University',
    date: 'June 25-26, 2026',
    location: props.locale === 'zh' ? '深圳大学丽湖校区' : 'Shenzhen University, Lihu Campus',
    description: props.locale === 'zh' ? 'ICSF2026将于2026年6月25-26日在深圳大学丽湖校区举办，征稿截止2026年5月31日，诚邀学术界与业界人士投稿参会。' : 'ICSF 2026 will be held on June 25–26 at Shenzhen University. Paper submission deadline: May 31, 2026.',
    color: 'from-brand-purple to-brand-blue',
    tags: [props.locale === 'zh' ? '会议' : 'Conference', props.locale === 'zh' ? '征稿' : 'CFP'],
    link: '/sources/ICSF/ICSF26/index.html',
  },
  {
    id: 2,
    title: props.locale === 'zh' ? '研究 | 赵建良教授发文解码生成式AI范式迭代' : 'Research | Prof. Zhao Decodes Generative AI Paradigm Shifts',
    subtitle: props.locale === 'zh' ? 'Information Systems Frontiers' : 'Information Systems Frontiers',
    date: 'March 28, 2025',
    location: props.locale === 'zh' ? '港中大（深圳）经管学院' : 'SME, CUHK-Shenzhen',
    description: props.locale === 'zh' ? '港中大（深圳）经管学院赵建良教授的合作研究在国际信息系统前沿期刊《Information Systems Frontiers》线上发表' : 'Prof. Zhao Jianliang\'s collaborative research published online in Information Systems Frontiers',
    color: 'from-blue-500 to-cyan-500',
    tags: [props.locale === 'zh' ? '研究' : 'Research', props.locale === 'zh' ? '论文' : 'Paper'],
    link: '#',
  },
  {
    id: 3,
    title: 'ICSF2025 Shanghai',
    subtitle: 'July 1-2, 2025',
    date: 'July 1-2, 2025',
    location: props.locale === 'zh' ? '同济大学经济与管理学院' : 'Tongji University, Shanghai',
    description: props.locale === 'zh' ? '第十届智能金融国际研讨会将在上海举办，汇聚全球金融科技领域专家学者。' : 'The 10th ICSF will be held in Shanghai, gathering global FinTech experts.',
    color: 'from-emerald-500 to-teal-500',
    tags: [props.locale === 'zh' ? '会议' : 'Conference', props.locale === 'zh' ? '上海' : 'Shanghai'],
    link: 'https://sem.tongji.edu.cn/ICSF2025/',
  },
])

const nextSlide = () => { activeIndex.value = (activeIndex.value + 1) % newsItems.value.length }
const prevSlide = () => { activeIndex.value = (activeIndex.value - 1 + newsItems.value.length) % newsItems.value.length }

onMounted(() => {
  gsap.context(() => {
    gsap.fromTo('.news-title', { opacity: 0, y: 40 }, { opacity: 1, y: 0, duration: 0.8, ease: 'expo.out', scrollTrigger: { trigger: sectionRef.value, start: 'top 70%', toggleActions: 'play none none reverse' } })
    gsap.fromTo('.news-slider', { opacity: 0, y: 60 }, { opacity: 1, y: 0, duration: 0.8, ease: 'expo.out', scrollTrigger: { trigger: '.news-slider', start: 'top 75%', toggleActions: 'play none none reverse' } })
  }, sectionRef)
})
</script>
