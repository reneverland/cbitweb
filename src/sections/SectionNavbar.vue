<template>
  <nav
    class="fixed top-0 left-0 right-0 z-50 transition-all duration-500 custom-expo"
    :class="isScrolled ? 'py-3' : 'py-5'"
  >
    <div
      class="mx-auto transition-all duration-500 custom-expo"
      :class="isScrolled
        ? 'max-w-6xl mx-4 sm:mx-6 lg:mx-auto lg:px-6 backdrop-blur-xl bg-white/85 dark:bg-gray-900/85 border border-white/30 dark:border-gray-700/30 shadow-glass rounded-full mt-3'
        : 'max-w-7xl px-4 sm:px-6 lg:px-8'"
    >
      <div class="flex items-center justify-between h-14">
        <div class="flex items-center gap-3">
          <img :src="isDark ? '/sources/logonight.png' : '/sources/logo3@2x.png'" alt="CBIT" class="h-10">
        </div>

        <div class="hidden lg:flex items-center gap-1">
          <button
            v-for="link in navLinks"
            :key="link.href"
            @click="scrollToSection(link.href)"
            class="px-4 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors rounded-full hover:bg-gray-100 dark:hover:bg-gray-800/50"
          >
            {{ link.label }}
          </button>
        </div>

        <div class="flex items-center gap-2">
          <button
            @click="$emit('toggle-icsf')"
            class="px-3 h-9 bg-gradient-brand rounded-full shadow-glow flex items-center gap-1.5 transition-all duration-300 hover:scale-105 hover:shadow-lg relative"
          >
            <i class="ri-calendar-event-line text-white text-sm"></i>
            <span class="text-xs font-bold text-white">ICSF</span>
            <span class="absolute -top-1 -right-1 w-2.5 h-2.5 bg-red-500 rounded-full animate-pulse"></span>
          </button>
          <button
            @click="$emit('toggle-theme')"
            class="w-9 h-9 rounded-full flex items-center justify-center transition-all duration-300 hover:scale-105 hover:bg-gray-100 dark:hover:bg-gray-800"
          >
            <i class="ri-sun-line text-yellow-500 text-lg" v-if="!isDark"></i>
            <i class="ri-moon-line text-blue-400 text-lg" v-else></i>
          </button>
          <button
            @click="$emit('toggle-locale')"
            class="px-3 h-9 rounded-full flex items-center gap-1.5 transition-all duration-300 hover:scale-105 hover:bg-gray-100 dark:hover:bg-gray-800"
          >
            <i class="ri-translate-2 text-brand-purple text-lg"></i>
            <span class="text-xs font-medium text-foreground">{{ locale === 'zh' ? '中/EN' : 'EN/中' }}</span>
          </button>
          <button
            class="lg:hidden w-9 h-9 rounded-full flex items-center justify-center hover:bg-gray-100 dark:hover:bg-gray-800"
            @click="isMobileMenuOpen = !isMobileMenuOpen"
          >
            <i :class="isMobileMenuOpen ? 'ri-close-line' : 'ri-menu-line'" class="text-xl text-foreground"></i>
          </button>
        </div>
      </div>
    </div>
  </nav>

  <Teleport to="body">
    <div
      v-if="isMobileMenuOpen"
      class="fixed inset-0 z-40 lg:hidden transition-all duration-500"
    >
      <div class="absolute inset-0 bg-black/20 backdrop-blur-sm" @click="isMobileMenuOpen = false" />
      <div class="absolute top-24 left-4 right-4 bg-white dark:bg-gray-800 rounded-3xl shadow-card-hover p-6">
        <div class="flex flex-col gap-2">
          <button
            v-for="link in navLinks"
            :key="link.href"
            @click="scrollToSection(link.href); isMobileMenuOpen = false"
            class="px-4 py-3 text-left text-base font-medium text-foreground hover:text-brand-purple hover:bg-brand-purple-light/50 rounded-xl transition-all"
          >
            {{ link.label }}
          </button>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { i18n } from '../locales/index.js'

const props = defineProps({
  isDark: Boolean,
  locale: { type: String, default: 'en' }
})

defineEmits(['toggle-theme', 'toggle-locale', 'toggle-icsf'])

const isScrolled = ref(false)
const isMobileMenuOpen = ref(false)

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

const scrollToSection = (href) => {
  const el = document.querySelector(href)
  if (el) el.scrollIntoView({ behavior: 'smooth' })
}

const handleScroll = () => { isScrolled.value = window.scrollY > 50 }

onMounted(() => window.addEventListener('scroll', handleScroll, { passive: true }))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))
</script>
