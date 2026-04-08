<template>
  <div class="min-h-screen transition-colors duration-500" :class="{ 'dark': isDark }">
    <div class="noise-overlay" />

    <SectionNavbar
      :is-dark="isDark"
      :locale="locale"
      @toggle-theme="toggleTheme"
      @toggle-locale="toggleLocale"
      @toggle-icsf="showICSFMenu = !showICSFMenu"
    />

    <main>
      <SectionHero :locale="locale" :is-dark="isDark" />
      <SectionAbout :locale="locale" />
      <SectionOrganization :locale="locale" />
      <SectionNews :locale="locale" />
      <SectionTeam :locale="locale" />
      <SectionConferences :locale="locale" />
      <SectionProjects :locale="locale" />
    </main>

    <SectionFooter :locale="locale" />

    <!-- ICSF Dropdown Menu -->
    <Teleport to="body">
      <div
        v-if="showICSFMenu"
        class="fixed inset-0 z-[9998] bg-black/30 backdrop-blur-sm"
        @click="showICSFMenu = false"
      >
        <div
          class="absolute top-20 right-6 bg-white dark:bg-gray-800 rounded-2xl shadow-2xl p-6 w-80 max-h-[70vh] overflow-y-auto"
          @click.stop
        >
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-lg font-display font-bold text-foreground flex items-center gap-2">
              <i class="ri-calendar-event-line text-brand-purple"></i>
              {{ locale === 'zh' ? 'ICSF会议系列' : 'ICSF Conference Series' }}
            </h3>
            <button
              @click="showICSFMenu = false"
              class="w-8 h-8 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 flex items-center justify-center transition-colors"
            >
              <i class="ri-close-line text-muted-foreground"></i>
            </button>
          </div>
          <p class="text-sm text-muted-foreground mb-4">
            {{ locale === 'zh' ? 'International Conference on Smart Finance（智能金融国际会议）' : 'International Conference on Smart Finance' }}
          </p>
          <a
            href="/icsfconference.html"
            class="block mb-4 p-3 rounded-xl bg-gradient-brand text-white text-center font-semibold text-sm hover:opacity-90 transition-all shadow-glow"
          >
            <i class="ri-global-line mr-1.5"></i>
            {{ locale === 'zh' ? '查看全部会议 →' : 'View All Conferences →' }}
          </a>
          <div class="space-y-2">
            <a
              v-for="year in icsfYears"
              :key="year.year"
              :href="year.link"
              target="_blank"
              class="block p-3 rounded-xl bg-brand-purple-light/30 dark:bg-brand-purple/10 hover:shadow-card transition-all duration-300 group"
            >
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 rounded-full bg-gradient-brand flex items-center justify-center text-white font-display font-bold text-sm shadow-glow">
                    {{ year.year }}
                  </div>
                  <div>
                    <div class="font-semibold text-foreground group-hover:text-brand-purple transition-colors">
                      ICSF {{ year.year }}
                    </div>
                    <div class="text-xs text-muted-foreground">
                      {{ year.location }}
                    </div>
                  </div>
                </div>
                <i class="ri-arrow-right-line text-muted-foreground group-hover:text-brand-purple group-hover:translate-x-1 transition-all"></i>
              </div>
            </a>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import SectionNavbar from './sections/SectionNavbar.vue'
import SectionHero from './sections/SectionHero.vue'
import SectionAbout from './sections/SectionAbout.vue'
import SectionOrganization from './sections/SectionOrganization.vue'
import SectionNews from './sections/SectionNews.vue'
import SectionTeam from './sections/SectionTeam.vue'
import SectionConferences from './sections/SectionConferences.vue'
import SectionProjects from './sections/SectionProjects.vue'
import SectionFooter from './sections/SectionFooter.vue'

const isDark = ref(false)
const locale = ref('zh')
const showICSFMenu = ref(false)

const icsfYears = ref([
  { year: '2026', location: 'Shenzhen, China', link: '/sources/ICSF/ICSF26/index.html' },
  { year: '2025', location: 'Shanghai, China', link: 'https://sem.tongji.edu.cn/ICSF2025/' },
  { year: '2024', location: 'Hefei, China', link: '/sources/ICSF/ICSF24/index.html' },
  { year: '2023', location: 'Dubai, UAE', link: '/sources/ICSF/ICSF23/index.html' },
  { year: '2022', location: 'Hong Kong (Online)', link: '/sources/ICSF/ICSF22/index.html' },
  { year: '2021', location: 'Shenzhen, China (Online)', link: '/sources/ICSF/ICSF21/index.html' },
  { year: '2020', location: 'Beidaihe, China (Online)', link: '/sources/ICSF/ICSF20/index.html' },
  { year: '2019', location: 'Beijing, China', link: '/sources/ICSF/ICSF19/index.html' },
  { year: '2018', location: 'Shenzhen, China', link: '/sources/ICSF/ICSF18/index.html' },
  { year: '2017', location: 'Guangzhou, China', link: '/sources/ICSF/ICSF17/index.html' },
  { year: '2016', location: 'Shenzhen, China', link: '/sources/ICSF/ICSF16/index.html' },
])

const toggleTheme = () => { isDark.value = !isDark.value }
const toggleLocale = () => { locale.value = locale.value === 'zh' ? 'en' : 'zh' }

watch(isDark, (val) => {
  document.documentElement.classList.toggle('dark', val)
  document.body.classList.toggle('dark', val)
}, { immediate: true })
</script>
