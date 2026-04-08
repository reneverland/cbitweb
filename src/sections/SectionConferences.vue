<template>
  <section id="cooperation" ref="sectionRef" class="relative py-24 lg:py-32 overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-white via-gray-50/20 to-white dark:from-gray-900 dark:via-gray-800/20 dark:to-gray-900" />

    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="text-center mb-16">
        <div class="conf-title inline-flex items-center gap-2 px-4 py-2 rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 border border-brand-purple/20 mb-6">
          <i class="ri-history-line text-brand-purple"></i>
          <span class="text-sm font-medium text-brand-purple-dark dark:text-brand-purple-light">{{ t('conf.badge') }}</span>
        </div>
        <h2 class="conf-title font-display text-4xl sm:text-5xl font-bold text-foreground mb-4">
          {{ t('conf.title') }} <span class="text-gradient">{{ t('conf.titleHighlight') }}</span>
        </h2>
        <p class="conf-title text-lg text-muted-foreground max-w-2xl mx-auto">{{ t('conf.subtitle') }}</p>
      </div>

      <!-- Toggle button to show/hide timeline -->
      <div class="flex justify-center mb-8">
        <button @click="showTimeline = !showTimeline"
          class="px-8 py-4 rounded-2xl border border-gray-200 dark:border-gray-700 text-base font-medium text-foreground hover:bg-brand-purple-light/30 dark:hover:bg-brand-purple/10 transition-all flex items-center gap-3 shadow-card hover:shadow-card-hover">
          <i class="ri-time-line text-brand-purple text-xl"></i>
          {{ showTimeline ? (locale === 'zh' ? '收起会议历史' : 'Hide Conference History') : (locale === 'zh' ? '查看 ' + conferences.length + ' 届会议历史' : 'View ' + conferences.length + ' Conference History') }}
          <i :class="showTimeline ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'" class="text-brand-purple text-lg"></i>
        </button>
      </div>

      <div v-if="showTimeline" ref="timelineRef" class="relative">
        <div class="absolute left-4 md:left-1/2 top-0 bottom-0 w-px bg-gradient-to-b from-brand-purple via-brand-blue to-transparent md:-translate-x-1/2" />

        <div class="space-y-8">
          <div v-for="(conf, index) in visibleConferences" :key="conf.year"
            class="timeline-item relative grid md:grid-cols-2 gap-8" :class="index % 2 === 0 ? '' : 'md:text-right'">
            <div class="absolute left-4 md:left-1/2 top-0 w-8 h-8 rounded-full bg-white dark:bg-gray-800 border-4 border-brand-purple shadow-glow md:-translate-x-1/2 z-10 flex items-center justify-center">
              <div :class="`w-3 h-3 rounded-full bg-gradient-to-br ${conf.color}`" />
            </div>

            <div :class="`pl-16 md:pl-0 ${index % 2 === 0 ? 'md:pr-16' : 'md:pl-16 md:col-start-2'}`">
              <div class="group rounded-3xl bg-white dark:bg-gray-800 border border-gray-200/50 dark:border-gray-700/50 shadow-card hover:shadow-card-hover transition-all duration-500 overflow-hidden cursor-pointer"
                :class="expandedYear === conf.year ? 'ring-2 ring-brand-purple/30' : ''"
                @click="expandedYear = expandedYear === conf.year ? null : conf.year">
                <div :class="`h-2 bg-gradient-to-r ${conf.color}`" />
                <div class="p-6">
                  <div class="flex items-start justify-between mb-4">
                    <div>
                      <div class="flex items-center gap-3 mb-2">
                        <span class="font-display text-3xl font-bold text-gradient">{{ conf.year }}</span>
                        <span v-if="conf.status === 'upcoming'" class="px-2 py-0.5 text-xs rounded-full bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 font-medium">{{ t('conf.upcoming') }}</span>
                      </div>
                      <h3 class="font-display text-xl font-semibold text-foreground">{{ conf.title }}</h3>
                      <p class="text-sm text-muted-foreground">{{ conf.subtitle }}</p>
                    </div>
                    <i class="ri-arrow-down-s-line text-muted-foreground transition-transform duration-300" :class="expandedYear === conf.year ? 'rotate-180' : ''"></i>
                  </div>
                  <div class="flex flex-wrap gap-4 text-sm text-muted-foreground mb-4">
                    <div class="flex items-center gap-1.5"><i class="ri-calendar-line text-brand-purple"></i>{{ conf.date }}</div>
                    <div class="flex items-center gap-1.5"><i class="ri-map-pin-line text-brand-purple"></i>{{ conf.location }}</div>
                  </div>
                  <div class="overflow-hidden transition-all duration-500" :class="expandedYear === conf.year ? 'max-h-64 opacity-100' : 'max-h-0 opacity-0'">
                    <div class="pt-4 border-t border-gray-200/50 dark:border-gray-700/50 space-y-4">
                      <div class="flex gap-2">
                        <a :href="conf.link" target="_blank"
                          class="px-4 py-2 text-sm rounded-full bg-gradient-brand text-white hover:opacity-90 flex items-center gap-1">
                          <i class="ri-external-link-line"></i>{{ t('conf.website') }}
                        </a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div v-if="index % 2 === 0" class="hidden md:block" />
          </div>
        </div>

        <!-- Show more / less toggle for older conferences -->
        <div v-if="conferences.length > 3" class="flex justify-center mt-8">
          <button @click="showAll = !showAll"
            class="px-6 py-3 rounded-full border border-gray-200 dark:border-gray-700 text-sm font-medium text-foreground hover:bg-brand-purple-light/30 dark:hover:bg-brand-purple/10 transition-all flex items-center gap-2">
            <i :class="showAll ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'" class="text-brand-purple"></i>
            {{ showAll ? (locale === 'zh' ? '收起历史会议' : 'Collapse') : (locale === 'zh' ? '展开全部 ' + conferences.length + ' 届会议' : 'Show all ' + conferences.length + ' conferences') }}
          </button>
        </div>
      </div>

      <div class="mt-12 flex justify-center">
        <a href="/icsfconference.html"
          class="px-8 py-4 rounded-2xl border-2 border-brand-purple/30 text-foreground hover:bg-brand-purple-light/30 dark:hover:bg-brand-purple/10 transition-all flex items-center gap-3 text-base font-medium shadow-card hover:shadow-card-hover">
          <i class="ri-global-line text-brand-purple text-xl"></i>
          {{ locale === 'zh' ? '查看 ICSF 全部会议详情' : 'View All ICSF Conferences' }}
          <i class="ri-arrow-right-line text-brand-purple"></i>
        </a>
      </div>

      <div class="mt-8 text-center">
        <div class="inline-flex flex-col sm:flex-row items-center gap-4 p-6 rounded-3xl bg-gradient-to-r from-brand-purple to-brand-blue text-white shadow-glow">
          <div class="text-left">
            <h4 class="font-display font-semibold text-lg">{{ t('conf.cfpTitle') }}</h4>
            <p class="text-sm text-white/80">{{ t('conf.cfpDeadline') }}</p>
          </div>
          <a href="/sources/ICSF/ICSF26/index.html" target="_blank" class="px-5 py-2.5 rounded-full bg-white text-brand-purple font-medium hover:bg-white/90 text-sm flex items-center gap-2">
            <i class="ri-file-text-line"></i>{{ t('conf.cfpBtn') }}
          </a>
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
const timelineRef = ref(null)
const showTimeline = ref(false)
const expandedYear = ref('2026')
const showAll = ref(false)

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) { value = value?.[k] }
  return value || key
})

const confColors = ['from-brand-purple to-brand-blue', 'from-blue-500 to-cyan-500', 'from-emerald-500 to-teal-500', 'from-violet-500 to-purple-500', 'from-orange-500 to-amber-500', 'from-pink-500 to-rose-500', 'from-cyan-500 to-sky-500', 'from-indigo-500 to-blue-500', 'from-brand-purple to-brand-blue', 'from-emerald-500 to-teal-500', 'from-blue-500 to-cyan-500']

const conferences = computed(() => [
  { year: '2026', title: 'ICSF2026', subtitle: props.locale === 'zh' ? '第11届国际智慧金融峰会' : '11th International Conference on Smart Finance', location: props.locale === 'zh' ? '深圳大学' : 'Shenzhen University', date: 'June 25-26, 2026', status: 'upcoming', link: '/sources/ICSF/ICSF26/index.html', color: confColors[0] },
  { year: '2025', title: 'ICSF2025', subtitle: props.locale === 'zh' ? '第十届智能金融国际研讨会' : '10th ICSF', location: props.locale === 'zh' ? '同济大学 · 上海' : 'Tongji University, Shanghai', date: 'July 1-2, 2025', status: 'completed', link: 'https://sem.tongji.edu.cn/ICSF2025/', color: confColors[1] },
  { year: '2024', title: 'ICSF2024', subtitle: props.locale === 'zh' ? '第九届智能金融国际研讨会' : '9th ICSF', location: props.locale === 'zh' ? '中国科学技术大学 · 安徽' : 'USTC, Anhui', date: 'July 27-28, 2024', status: 'completed', link: '/sources/ICSF/ICSF24/index.html', color: confColors[2] },
  { year: '2023', title: 'ICSF2023', subtitle: props.locale === 'zh' ? '第八届智能金融国际研讨会' : '8th ICSF', location: props.locale === 'zh' ? '迪拜' : 'Dubai, UAE', date: 'August 4-6, 2023', status: 'completed', link: '/sources/ICSF/ICSF23/index.html', color: confColors[3] },
  { year: '2022', title: 'ICSF2022', subtitle: props.locale === 'zh' ? '第七届智能金融国际研讨会' : '7th ICSF', location: 'Hong Kong (Online)', date: 'August 19-20, 2022', status: 'completed', link: '/sources/ICSF/ICSF22/index.html', color: confColors[4] },
  { year: '2021', title: 'ICSF2021', subtitle: props.locale === 'zh' ? '第六届智能金融国际研讨会' : '6th ICSF', location: 'Shenzhen (Online)', date: 'August 20-21, 2021', status: 'completed', link: '/sources/ICSF/ICSF21/index.html', color: confColors[5] },
  { year: '2020', title: 'ICSF2020', subtitle: props.locale === 'zh' ? '第五届智能金融国际研讨会' : '5th ICSF', location: 'Beidaihe (Online)', date: 'August 20-22, 2020', status: 'completed', link: '/sources/ICSF/ICSF20/index.html', color: confColors[6] },
  { year: '2019', title: 'ICSF2019', subtitle: props.locale === 'zh' ? '第四届智能金融国际研讨会' : '4th ICSF', location: 'Beijing', date: 'July 26-28, 2019', status: 'completed', link: '/sources/ICSF/ICSF19/index.html', color: confColors[7] },
  { year: '2018', title: 'ICSF2018', subtitle: props.locale === 'zh' ? '第三届智能金融国际研讨会' : '3rd ICSF', location: 'Shenzhen', date: 'July 07-08, 2018', status: 'completed', link: '/sources/ICSF/ICSF18/index.html', color: confColors[8] },
  { year: '2017', title: 'ICSF2017', subtitle: props.locale === 'zh' ? '第二届智能金融国际研讨会' : '2nd ICSF', location: 'Guangzhou', date: 'July 16-17, 2017', status: 'completed', link: '/sources/ICSF/ICSF17/index.html', color: confColors[9] },
  { year: '2016', title: 'ICSF2016', subtitle: props.locale === 'zh' ? '首届智能金融国际研讨会' : '1st ICSF', location: 'Shenzhen', date: 'May 20-21, 2016', status: 'completed', link: '/sources/ICSF/ICSF16/index.html', color: confColors[10] },
])

const visibleConferences = computed(() => showAll.value ? conferences.value : conferences.value.slice(0, 3))

onMounted(() => {
  gsap.context(() => {
    gsap.fromTo('.conf-title', { opacity: 0, y: 40 }, { opacity: 1, y: 0, duration: 0.8, ease: 'expo.out', scrollTrigger: { trigger: sectionRef.value, start: 'top 70%', toggleActions: 'play none none reverse' } })
    gsap.fromTo(timelineRef.value?.querySelectorAll('.timeline-item') || [], { opacity: 0, x: -30 }, { opacity: 1, x: 0, duration: 0.6, stagger: 0.1, ease: 'expo.out', scrollTrigger: { trigger: timelineRef.value, start: 'top 75%', toggleActions: 'play none none reverse' } })
  }, sectionRef)
})
</script>
