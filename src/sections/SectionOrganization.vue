<template>
  <section id="research" ref="sectionRef" class="relative py-24 lg:py-32 overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-white via-brand-purple-light/10 to-white dark:from-gray-900 dark:via-gray-800/10 dark:to-gray-900" />
    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-brand-purple/5 rounded-full blur-3xl" />

    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="text-center mb-16">
        <div class="org-title inline-flex items-center gap-2 px-4 py-2 rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 border border-brand-purple/20 mb-6">
          <i class="ri-building-2-line text-brand-purple"></i>
          <span class="text-sm font-medium text-brand-purple-dark dark:text-brand-purple-light">{{ t('org.badge') }}</span>
        </div>
        <h2 class="org-title font-display text-4xl sm:text-5xl font-bold text-foreground mb-4">
          {{ t('org.title') }}<span class="text-gradient">{{ t('org.titleHighlight') }}</span>
        </h2>
        <p class="org-title text-lg text-muted-foreground max-w-2xl mx-auto">{{ t('org.description') }}</p>
      </div>

      <div class="flex justify-center mb-12">
        <div class="relative">
          <div class="w-24 h-24 rounded-full bg-gradient-brand flex items-center justify-center shadow-glow animate-pulse-glow">
            <div class="text-center text-white">
              <div class="font-display font-bold text-xl">CBIT</div>
              <div class="text-xs opacity-80">{{ t('org.cbitCore') }}</div>
            </div>
          </div>
          <div class="absolute inset-0 animate-spin" style="animation-duration: 20s">
            <div class="absolute -top-2 left-1/2 w-3 h-3 bg-brand-purple rounded-full" />
          </div>
          <div class="absolute inset-0 animate-spin" style="animation-duration: 15s; animation-direction: reverse">
            <div class="absolute top-1/2 -right-2 w-3 h-3 bg-brand-blue rounded-full" />
          </div>
        </div>
      </div>

      <div ref="cardsRef" class="grid md:grid-cols-3 gap-6 lg:gap-8">
        <div v-for="dept in departments" :key="dept.id"
          class="dept-card group relative rounded-3xl overflow-hidden cursor-pointer transition-all duration-500"
          :class="activeDept === dept.id ? 'scale-105 shadow-card-hover z-10' : 'hover:-translate-y-2 hover:shadow-card-hover'"
          @click="activeDept = activeDept === dept.id ? null : dept.id">
          <div :class="`absolute inset-0 ${dept.bgColor}`" />
          <div :class="`absolute inset-0 bg-gradient-to-br ${dept.color} opacity-0 group-hover:opacity-10 transition-opacity duration-500`" />
          <div class="relative p-8">
            <div :class="`w-16 h-16 rounded-2xl bg-gradient-to-br ${dept.color} flex items-center justify-center mb-6 shadow-lg group-hover:scale-110 transition-transform duration-500`">
              <i :class="dept.icon" class="text-white text-2xl"></i>
            </div>
            <h3 class="font-display text-xl font-semibold text-foreground mb-1">{{ dept.title }}</h3>
            <p class="text-sm text-muted-foreground mb-4">{{ dept.subtitle }}</p>
            <p class="text-muted-foreground leading-relaxed mb-6">{{ dept.desc }}</p>
            <div class="space-y-2">
              <div v-for="(f, idx) in dept.features" :key="idx" class="flex items-center gap-2 text-sm text-muted-foreground">
                <i class="ri-arrow-right-s-line text-brand-purple"></i>{{ f }}
              </div>
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
const cardsRef = ref(null)
const activeDept = ref(null)

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) { value = value?.[k] }
  return value || key
})

const departments = computed(() => [
  { id: 'research', icon: 'ri-microscope-line', title: t.value('org.dept1Title'), subtitle: t.value('org.dept1Subtitle'), desc: t.value('org.dept1Desc'), color: 'from-violet-500 to-purple-600', bgColor: 'bg-violet-50 dark:bg-violet-900/10', features: t.value('org.dept1Features') },
  { id: 'education', icon: 'ri-graduation-cap-line', title: t.value('org.dept2Title'), subtitle: t.value('org.dept2Subtitle'), desc: t.value('org.dept2Desc'), color: 'from-blue-500 to-cyan-500', bgColor: 'bg-blue-50 dark:bg-blue-900/10', features: t.value('org.dept2Features') },
  { id: 'lab', icon: 'ri-flask-line', title: t.value('org.dept3Title'), subtitle: t.value('org.dept3Subtitle'), desc: t.value('org.dept3Desc'), color: 'from-emerald-500 to-teal-500', bgColor: 'bg-emerald-50 dark:bg-emerald-900/10', features: t.value('org.dept3Features') },
])

onMounted(() => {
  gsap.context(() => {
    gsap.fromTo('.org-title', { opacity: 0, y: 40 }, { opacity: 1, y: 0, duration: 0.8, ease: 'expo.out', scrollTrigger: { trigger: sectionRef.value, start: 'top 70%', toggleActions: 'play none none reverse' } })
    gsap.fromTo(cardsRef.value?.querySelectorAll('.dept-card') || [], { opacity: 0, y: 60, scale: 0.9 }, { opacity: 1, y: 0, scale: 1, duration: 0.7, stagger: 0.15, ease: 'expo.out', scrollTrigger: { trigger: cardsRef.value, start: 'top 75%', toggleActions: 'play none none reverse' } })
  }, sectionRef)
})
</script>
