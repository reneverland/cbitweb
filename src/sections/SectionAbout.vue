<template>
  <section id="about" ref="sectionRef" class="relative py-24 lg:py-32 overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-white via-gray-50/30 to-white dark:from-gray-900 dark:via-gray-800/30 dark:to-gray-900" />
    <div class="absolute top-0 right-0 w-1/3 h-full bg-gradient-to-l from-brand-purple-light/20 dark:from-brand-purple/5 to-transparent" />
    <div class="absolute bottom-0 left-0 w-96 h-96 bg-brand-blue/5 rounded-full blur-3xl" />

    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="grid lg:grid-cols-2 gap-16 items-start">
        <div ref="contentRef" class="lg:sticky lg:top-32">
          <div class="reveal-item inline-flex items-center gap-2 px-4 py-2 rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 border border-brand-purple/20 mb-6">
            <i class="ri-lightbulb-line text-brand-purple"></i>
            <span class="text-sm font-medium text-brand-purple-dark dark:text-brand-purple-light">{{ t('about.badge') }}</span>
          </div>

          <h2 class="reveal-item font-display text-4xl sm:text-5xl font-bold text-foreground mb-6 leading-tight">
            {{ t('about.titlePrefix') }}<br />
            <span class="text-gradient">{{ t('about.titleHighlight') }}</span>
          </h2>

          <p class="reveal-item text-lg text-muted-foreground leading-relaxed mb-8">
            {{ t('about.description') }}
          </p>

          <div class="reveal-item space-y-4">
            <h3 class="font-display font-semibold text-lg mb-4">{{ t('about.researchAreas') }}</h3>
            <div v-for="(area, index) in researchAreas" :key="index"
              class="flex items-start gap-4 p-4 rounded-xl bg-white dark:bg-gray-800 border border-gray-200/50 dark:border-gray-700/50 shadow-card hover:shadow-card-hover transition-all hover:-translate-y-0.5">
              <div class="w-10 h-10 rounded-lg bg-brand-purple-light/50 dark:bg-brand-purple/20 flex items-center justify-center flex-shrink-0">
                <i :class="area.icon" class="text-brand-purple text-lg"></i>
              </div>
              <div>
                <h4 class="font-medium text-foreground">{{ area.title }}</h4>
                <p class="text-sm text-muted-foreground">{{ area.desc }}</p>
              </div>
            </div>
          </div>
        </div>

        <div ref="cardsRef" class="space-y-6">
          <div v-for="(feature, index) in features" :key="index"
            class="feature-card group relative p-8 rounded-3xl bg-white dark:bg-gray-800 border border-gray-200/50 dark:border-gray-700/50 shadow-card hover:shadow-card-hover transition-all duration-500 hover:-translate-y-1 overflow-hidden">
            <div :class="`absolute inset-0 bg-gradient-to-br ${feature.color} opacity-0 group-hover:opacity-5 transition-opacity duration-500`" />
            <div class="relative z-10">
              <div :class="`w-14 h-14 rounded-2xl bg-gradient-to-br ${feature.color} flex items-center justify-center mb-6 shadow-lg group-hover:scale-110 transition-transform duration-500`">
                <i :class="feature.icon" class="text-white text-2xl"></i>
              </div>
              <h3 class="font-display text-xl font-semibold text-foreground mb-3">{{ feature.title }}</h3>
              <p class="text-muted-foreground leading-relaxed">{{ feature.desc }}</p>
            </div>
            <div class="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-transparent via-transparent to-gray-100/30 dark:to-gray-700/30 rounded-bl-full" />
          </div>

          <div class="feature-card p-8 rounded-3xl bg-gradient-brand text-white shadow-glow">
            <h3 class="font-display text-xl font-semibold mb-6">{{ t('about.missionTitle') }}</h3>
            <p class="text-white/90 leading-relaxed mb-6">{{ t('about.missionDesc') }}</p>
            <div class="flex gap-6">
              <div><div class="font-display text-3xl font-bold">2021</div><div class="text-sm text-white/70">{{ t('about.statYear') }}</div></div>
              <div class="w-px bg-white/30" />
              <div><div class="font-display text-3xl font-bold">3</div><div class="text-sm text-white/70">{{ t('about.statDepts') }}</div></div>
              <div class="w-px bg-white/30" />
              <div><div class="font-display text-3xl font-bold">20+</div><div class="text-sm text-white/70">{{ t('about.statPartners') }}</div></div>
            </div>
          </div>
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
const contentRef = ref(null)
const cardsRef = ref(null)

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) { value = value?.[k] }
  return value || key
})

const researchAreas = computed(() => [
  { icon: 'ri-links-line', title: t.value('about.area1Title'), desc: t.value('about.area1Desc') },
  { icon: 'ri-brain-line', title: t.value('about.area2Title'), desc: t.value('about.area2Desc') },
  { icon: 'ri-money-dollar-circle-line', title: t.value('about.area3Title'), desc: t.value('about.area3Desc') },
])

const features = computed(() => [
  { icon: 'ri-lightbulb-line', title: t.value('about.feature1Title'), desc: t.value('about.feature1Desc'), color: 'from-amber-500 to-orange-500' },
  { icon: 'ri-shield-check-line', title: t.value('about.feature2Title'), desc: t.value('about.feature2Desc'), color: 'from-emerald-500 to-teal-500' },
  { icon: 'ri-cpu-line', title: t.value('about.feature3Title'), desc: t.value('about.feature3Desc'), color: 'from-blue-500 to-cyan-500' },
])

onMounted(() => {
  const ctx = gsap.context(() => {
    gsap.fromTo(contentRef.value?.querySelectorAll('.reveal-item') || [], { opacity: 0, y: 40 }, {
      opacity: 1, y: 0, duration: 0.8, stagger: 0.15, ease: 'expo.out',
      scrollTrigger: { trigger: sectionRef.value, start: 'top 70%', toggleActions: 'play none none reverse' }
    })
    gsap.fromTo(cardsRef.value?.querySelectorAll('.feature-card') || [], { opacity: 0, y: 60, scale: 0.95 }, {
      opacity: 1, y: 0, scale: 1, duration: 0.7, stagger: 0.12, ease: 'expo.out',
      scrollTrigger: { trigger: cardsRef.value, start: 'top 75%', toggleActions: 'play none none reverse' }
    })
  }, sectionRef)
})
</script>
