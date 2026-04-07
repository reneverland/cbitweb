<template>
  <footer class="relative bg-gray-900 text-white overflow-hidden">
    <div class="absolute inset-0 opacity-5" style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 40px 40px" />
    <div class="absolute inset-0 bg-gradient-to-b from-transparent via-brand-purple/10 to-brand-purple/20" />

    <div class="relative z-10">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-12">
          <div class="lg:col-span-1">
            <div class="flex items-center gap-3 mb-6">
              <img src="/sources/logonight.png" alt="CBIT" class="h-12" />
            </div>
            <p class="text-sm text-white/70 leading-relaxed mb-6">{{ t('footer.description') }}</p>
            <div class="flex gap-3">
              <a href="https://github.com/reneverland/" target="_blank" class="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center hover:bg-white/20 transition-colors">
                <i class="ri-github-fill text-lg"></i>
              </a>
              <a href="#" class="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center hover:bg-white/20 transition-colors">
                <i class="ri-linkedin-box-fill text-lg"></i>
              </a>
              <a href="#" class="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center hover:bg-white/20 transition-colors">
                <i class="ri-twitter-x-fill text-lg"></i>
              </a>
            </div>
          </div>

          <div>
            <h4 class="font-display font-semibold text-lg mb-6">{{ t('footer.quickLinks') }}</h4>
            <ul class="space-y-3">
              <li v-for="link in navLinks" :key="link.href">
                <button @click="scrollToSection(link.href)" class="text-sm text-white/70 hover:text-white transition-colors flex items-center gap-2 group">
                  <span class="w-1.5 h-1.5 rounded-full bg-brand-purple opacity-0 group-hover:opacity-100 transition-opacity" />
                  {{ link.label }}
                </button>
              </li>
            </ul>
          </div>

          <div>
            <h4 class="font-display font-semibold text-lg mb-6">{{ t('footer.resources') }}</h4>
            <ul class="space-y-3">
              <li v-for="res in resources" :key="res.label">
                <a :href="res.href" class="text-sm text-white/70 hover:text-white transition-colors flex items-center gap-2 group">
                  <i class="ri-external-link-line text-xs opacity-0 group-hover:opacity-100 transition-opacity"></i>
                  {{ res.label }}
                </a>
              </li>
            </ul>
          </div>

          <div>
            <h4 class="font-display font-semibold text-lg mb-6">{{ t('footer.contactUs') }}</h4>
            <ul class="space-y-4">
              <li class="flex items-start gap-3">
                <i class="ri-map-pin-line text-brand-purple flex-shrink-0 mt-0.5"></i>
                <span class="text-sm text-white/70 whitespace-pre-line">{{ t('footer.address') }}</span>
              </li>
              <li class="flex items-center gap-3">
                <i class="ri-mail-line text-brand-purple flex-shrink-0"></i>
                <a href="mailto:renshi@cuhk.edu.cn" class="text-sm text-white/70 hover:text-white transition-colors">renshi@cuhk.edu.cn</a>
              </li>
            </ul>
            <div class="mt-6">
              <h5 class="text-sm font-medium mb-3">{{ t('footer.subscribe') }}</h5>
              <div class="flex gap-2">
                <input type="email" :placeholder="t('footer.subscribePlaceholder')" class="flex-1 px-4 py-2 rounded-full bg-white/10 border border-white/20 text-sm placeholder:text-white/40 focus:outline-none focus:ring-2 focus:ring-brand-purple/50" />
                <button class="px-4 py-2 rounded-full bg-gradient-brand hover:opacity-90 text-sm font-medium">{{ t('footer.subscribeBtn') }}</button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="border-t border-white/10">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div class="flex flex-col md:flex-row items-center justify-between gap-4">
            <div class="flex items-center gap-2 text-sm text-white/50">
              <span>{{ t('footer.copyright') }}</span>
              <span class="hidden md:inline">·</span>
              <span class="hidden md:inline">{{ t('footer.copyrightOrg') }}</span>
            </div>
            <div class="flex items-center gap-6 text-sm text-white/50">
              <a href="/privacy.html" class="hover:text-white transition-colors">{{ t('footer.privacy') }}</a>
              <a href="/terms.html" class="hover:text-white transition-colors">{{ t('footer.terms') }}</a>
              <a href="/sitemap.html" class="hover:text-white transition-colors">{{ t('footer.sitemap') }}</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { computed } from 'vue'
import { i18n } from '../locales/index.js'

const props = defineProps({ locale: { type: String, default: 'en' } })

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) { value = value?.[k] }
  return value || key
})

const navLinks = computed(() => [
  { label: t.value('nav.home'), href: '#hero' },
  { label: t.value('nav.about'), href: '#about' },
  { label: t.value('nav.research'), href: '#research' },
  { label: t.value('nav.team'), href: '#team' },
  { label: t.value('nav.publications'), href: '#publications' },
  { label: t.value('nav.cooperation'), href: '#cooperation' },
])

const resources = computed(() => [
  { label: t.value('footer.resIcsf'), href: '/sources/ICSF/' },
  { label: props.locale === 'zh' ? '大学官网' : 'University', href: 'https://cuhk.edu.cn' },
  { label: props.locale === 'zh' ? '数据科学与信息经济学院' : 'SIDE', href: 'https://side.cuhk.edu.cn' },
  { label: t.value('footer.resOpenSource'), href: 'https://github.com/reneverland/' },
])

const scrollToSection = (href) => {
  const el = document.querySelector(href)
  if (el) el.scrollIntoView({ behavior: 'smooth' })
}
</script>
