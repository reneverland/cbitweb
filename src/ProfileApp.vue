<template>
  <div class="main-page-container min-h-screen flex flex-col transition-all duration-500" :class="[isDark ? 'dark dark-mode' : '']">
    <!-- Background -->
    <div class="fixed inset-0 bg-gradient-to-br from-white via-brand-purple-light/30 to-blue-50/10 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900 -z-10" />
    <div class="fixed inset-0 overflow-hidden -z-10">
      <div class="absolute top-20 left-10 w-72 h-72 bg-brand-purple/10 rounded-full blur-3xl animate-float" />
      <div class="absolute bottom-20 right-10 w-96 h-96 bg-brand-blue/10 rounded-full blur-3xl animate-float" style="animation-delay: 2s" />
    </div>
    <div class="fixed inset-0 opacity-[0.03] -z-10" style="background-image: linear-gradient(#6941C6 1px, transparent 1px), linear-gradient(90deg, #6941C6 1px, transparent 1px); background-size: 60px 60px" />

    <!-- Top Bar -->
    <header class="sticky top-0 z-50 backdrop-blur-xl bg-white/80 dark:bg-gray-900/80 border-b border-gray-200/50 dark:border-gray-700/50">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 flex items-center justify-between h-14">
        <a href="/" class="flex items-center gap-2">
          <img :src="isDark ? '/sources/logonight.png' : '/sources/logo3@2x.png'" alt="CBIT" class="h-8">
        </a>
        <div class="flex items-center gap-1.5">
          <a href="mailto:renshi@cuhk.edu.cn" class="w-8 h-8 rounded-full flex items-center justify-center hover:bg-gray-100 dark:hover:bg-gray-800 transition-all">
            <i class="ri-mail-line text-muted-foreground text-sm"></i>
          </a>
          <a href="https://github.com/reneverland" target="_blank" class="w-8 h-8 rounded-full flex items-center justify-center hover:bg-gray-100 dark:hover:bg-gray-800 transition-all">
            <i class="ri-github-fill text-muted-foreground text-sm"></i>
          </a>
          <button @click="toggleTheme" class="w-8 h-8 rounded-full flex items-center justify-center hover:bg-gray-100 dark:hover:bg-gray-800 transition-all">
            <i class="ri-sun-line text-yellow-500 text-sm" v-if="!isDark"></i>
            <i class="ri-moon-line text-blue-400 text-sm" v-else></i>
          </button>
          <button @click="toggleLocale" class="px-2.5 h-8 rounded-full flex items-center gap-1 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all">
            <i class="ri-translate-2 text-brand-purple text-sm"></i>
            <span class="text-xs font-medium text-foreground">{{ locale === 'zh' ? '中/EN' : 'EN/中' }}</span>
          </button>
        </div>
      </div>
    </header>

    <!-- Chat Header -->
    <div class="sticky top-14 z-40 backdrop-blur-xl bg-white/60 dark:bg-gray-900/60 border-b border-gray-200/30 dark:border-gray-700/30">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 py-3 flex items-center justify-between">
        <div class="flex items-center gap-3">
          <div class="relative cursor-pointer" @click="showAvatarModal = true">
            <img src="/sources/rendashi.jpeg" alt="Ren" class="w-10 h-10 rounded-full object-cover shadow-glow hover:scale-105 transition-transform" />
            <div class="absolute -bottom-0.5 -right-0.5 w-3 h-3 bg-green-500 rounded-full border-2 border-white dark:border-gray-900" />
          </div>
          <div>
            <h1 class="font-display font-semibold text-foreground text-sm">Ren AI</h1>
            <p class="text-xs text-muted-foreground">{{ locale === 'zh' ? '石仁达 · 在线' : 'Ren Shi · Online' }}</p>
          </div>
        </div>
        <div class="flex items-center gap-2">
          <span class="hidden sm:inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 border border-brand-purple/20 text-xs font-medium text-brand-purple-dark dark:text-brand-purple-light">
            <i class="ri-user-star-line"></i>Assistant Director · 开发主管
          </span>
          <a href="/" class="w-8 h-8 rounded-full flex items-center justify-center hover:bg-gray-100 dark:hover:bg-gray-800 transition-all" :title="locale === 'zh' ? '返回主页' : 'Home'">
            <i class="ri-home-line text-muted-foreground text-sm"></i>
          </a>
        </div>
      </div>
    </div>

    <!-- Chat Messages -->
    <div ref="chatAreaRef" class="flex-1 overflow-y-auto">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 py-6 space-y-6 pb-40">

        <!-- Each message block -->
        <template v-for="(msg, idx) in visibleMessages" :key="msg.id">

          <!-- === WELCOME === -->
          <div v-if="msg.type === 'welcome'" class="chat-msg flex gap-3">
            <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
              <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 space-y-2">
              <div class="inline-block bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm px-5 py-4 shadow-card border border-white/50 dark:border-gray-700/50 max-w-lg">
                <p class="text-sm text-foreground leading-relaxed" v-html="formatMd(t('profile.welcomeIntro'))"></p>
              </div>
              <span class="text-xs text-muted-foreground block">{{ locale === 'zh' ? '刚刚' : 'Just now' }}</span>
            </div>
          </div>

          <!-- === EDUCATION === -->
          <div v-else-if="msg.type === 'education'" class="chat-msg flex gap-3">
            <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
              <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 space-y-3 max-w-2xl">
              <div class="inline-block bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm px-5 py-3 shadow-card border border-white/50 dark:border-gray-700/50">
                <p class="text-sm text-foreground font-semibold flex items-center gap-2">
                  <i class="ri-graduation-cap-line text-brand-purple"></i>{{ locale === 'zh' ? '教育背景' : 'Education Background' }}
                </p>
              </div>
              <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                <div v-for="(edu, i) in educationData" :key="i"
                  class="bg-white dark:bg-gray-800 rounded-xl border border-gray-200/50 dark:border-gray-700/50 shadow-card hover:shadow-card-hover hover:-translate-y-1 transition-all duration-300 overflow-hidden">
                  <div :class="`h-1 bg-gradient-to-r ${edu.color}`" />
                  <div class="p-4">
                    <div :class="`w-9 h-9 rounded-lg bg-gradient-to-br ${edu.color} flex items-center justify-center mb-3`">
                      <i :class="edu.icon" class="text-white text-sm"></i>
                    </div>
                    <div class="text-xs font-semibold text-brand-purple mb-0.5">{{ edu.degree }}</div>
                    <h3 class="font-display font-bold text-foreground text-sm leading-tight">{{ edu.school }}</h3>
                    <p class="text-xs text-muted-foreground mt-0.5">{{ edu.field }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- === WORK === -->
          <div v-else-if="msg.type === 'work'" class="chat-msg flex gap-3">
            <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
              <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 max-w-2xl">
              <div class="bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm shadow-card border border-white/50 dark:border-gray-700/50 overflow-hidden">
                <div class="h-1 bg-gradient-to-r from-brand-purple to-brand-blue" />
                <div class="px-5 py-4">
                  <div class="flex items-center gap-3 mb-3">
                    <div class="w-9 h-9 rounded-lg bg-gradient-to-br from-brand-purple to-brand-blue flex items-center justify-center">
                      <i class="ri-building-line text-white text-sm"></i>
                    </div>
                    <div class="flex-1">
                      <h3 class="font-display font-bold text-foreground text-sm">{{ locale === 'zh' ? '工作经历' : 'Work Experience' }}</h3>
                      <p class="text-xs text-muted-foreground">CBIT · 2022 – {{ locale === 'zh' ? '至今' : 'Present' }}</p>
                    </div>
                    <span class="px-2 py-0.5 text-xs rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 text-brand-purple-dark dark:text-brand-purple-light font-medium">{{ locale === 'zh' ? '助理主任 & 开发主管' : 'Asst. Director & Dev Lead' }}</span>
                  </div>
                  <div class="text-sm text-muted-foreground leading-relaxed space-y-2" v-html="formatWorkContent()"></div>
                </div>
              </div>
            </div>
          </div>

          <!-- === TEACHING === -->
          <div v-else-if="msg.type === 'teaching'" class="chat-msg flex gap-3">
            <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
              <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 max-w-2xl">
              <div class="bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm shadow-card border border-white/50 dark:border-gray-700/50 overflow-hidden">
                <div class="h-1 bg-gradient-to-r from-blue-500 to-cyan-500" />
                <div class="px-5 py-4">
                  <div class="flex items-center gap-3 mb-3">
                    <div class="w-9 h-9 rounded-lg bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center">
                      <i class="ri-presentation-line text-white text-sm"></i>
                    </div>
                    <div class="flex-1">
                      <h3 class="font-display font-bold text-foreground text-sm">{{ locale === 'zh' ? '教学经历' : 'Teaching' }}</h3>
                      <p class="text-xs text-muted-foreground">IBA6002 Python · 2021 – {{ locale === 'zh' ? '至今' : 'Present' }}</p>
                    </div>
                    <span class="px-2 py-0.5 text-xs rounded-full bg-blue-100/60 dark:bg-blue-900/20 text-blue-700 dark:text-blue-300 font-medium">{{ locale === 'zh' ? '授课教师' : 'Instructor' }}</span>
                  </div>
                  <div class="space-y-1.5">
                    <div v-for="(item, i) in teachingHighlights" :key="i" class="flex items-start gap-2">
                      <i class="ri-checkbox-circle-line text-brand-purple flex-shrink-0 mt-0.5 text-xs"></i>
                      <span class="text-sm text-muted-foreground">{{ item }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- === RESEARCH === -->
          <div v-else-if="msg.type === 'research'" class="chat-msg flex gap-3">
            <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
              <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 max-w-2xl">
              <div class="inline-block bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm px-5 py-4 shadow-card border border-white/50 dark:border-gray-700/50">
                <p class="text-sm text-foreground font-semibold flex items-center gap-2 mb-3">
                  <i class="ri-lightbulb-flash-line text-brand-purple"></i>{{ locale === 'zh' ? '研究方向' : 'Research Interests' }}
                </p>
                <div class="flex flex-wrap gap-2">
                  <div v-for="(r, i) in researchAreas" :key="i"
                    class="flex items-center gap-2 px-3 py-2 rounded-xl bg-brand-purple-light/30 dark:bg-brand-purple/10 border border-brand-purple/10">
                    <div class="w-6 h-6 rounded-md bg-gradient-brand flex items-center justify-center flex-shrink-0">
                      <i :class="r.icon" class="text-white text-xs"></i>
                    </div>
                    <span class="text-xs font-medium text-foreground">{{ r.label }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- === PATENTS === -->
          <div v-else-if="msg.type === 'patents'" class="chat-msg flex gap-3">
            <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
              <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 max-w-2xl">
              <div class="inline-block bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm px-5 py-4 shadow-card border border-white/50 dark:border-gray-700/50">
                <p class="text-sm text-foreground font-semibold flex items-center gap-2 mb-3">
                  <i class="ri-shield-check-line text-amber-600"></i>{{ locale === 'zh' ? '专利' : 'Patents' }}
                </p>
                <div class="space-y-2">
                  <div v-for="(p, i) in patents" :key="i"
                    class="p-3 rounded-xl bg-amber-50/50 dark:bg-amber-900/10 border border-amber-200/50 dark:border-amber-800/30">
                    <h4 class="text-xs font-semibold text-foreground mb-1">{{ p.title }}</h4>
                    <span class="patent-badge inline-block px-2 py-0.5 text-xs rounded-full bg-amber-100 dark:bg-amber-900/30 text-amber-700 dark:text-amber-400 font-medium border border-amber-300 dark:border-amber-700">{{ p.number }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- === PAPERS === -->
          <div v-else-if="msg.type === 'papers'" class="chat-msg flex gap-3">
            <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
              <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 max-w-2xl">
              <div class="inline-block bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm px-5 py-4 shadow-card border border-white/50 dark:border-gray-700/50">
                <p class="text-sm text-foreground font-semibold flex items-center gap-2 mb-3">
                  <i class="ri-article-line text-brand-purple"></i>{{ locale === 'zh' ? '学术论文' : 'Publications' }}
                </p>
                <div class="space-y-3">
                  <div v-for="(paper, i) in papers" :key="i"
                    class="p-3 rounded-xl bg-brand-purple-light/20 dark:bg-brand-purple/10 border border-brand-purple/10 hover:border-brand-purple/30 transition-all">
                    <div class="flex items-start gap-2">
                      <span class="flex-shrink-0 w-6 h-6 rounded-md bg-gradient-brand flex items-center justify-center text-white text-xs font-bold mt-0.5">{{ i + 1 }}</span>
                      <div class="flex-1">
                        <h4 class="text-sm font-semibold text-foreground leading-snug">{{ paper.title }}</h4>
                        <p v-if="paper.venue" class="text-xs text-muted-foreground mt-1 italic">{{ paper.venue }}</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- === PROJECTS OVERVIEW === -->
          <div v-else-if="msg.type === 'projects'" class="chat-msg flex gap-3">
            <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
              <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 space-y-3 max-w-3xl">
              <div class="inline-block bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm px-5 py-3 shadow-card border border-white/50 dark:border-gray-700/50">
                <p class="text-sm text-foreground font-semibold flex items-center gap-2">
                  <i class="ri-rocket-line text-brand-purple"></i>{{ locale === 'zh' ? '主导项目（点击查看详情）' : 'Led Projects (click for details)' }}
                </p>
                <p class="text-xs text-muted-foreground mt-1">{{ locale === 'zh' ? '以下是我主导和参与的 AI 项目' : 'AI projects I have led and participated in' }}</p>
              </div>
              <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-2.5">
                <button v-for="(proj, i) in projects" :key="i" @click="openProject(i)"
                  class="text-left p-3 rounded-xl border transition-all duration-300 bg-white dark:bg-gray-800 border-gray-200/50 dark:border-gray-700/50 shadow-card hover:shadow-card-hover hover:-translate-y-1 group">
                  <div :class="`w-8 h-8 rounded-lg bg-gradient-to-br ${proj.color} flex items-center justify-center mb-2 text-white font-bold text-xs`">
                    {{ proj.icon }}
                  </div>
                  <h4 class="font-display font-semibold text-xs text-foreground leading-tight line-clamp-2 group-hover:text-brand-purple transition-colors">{{ locale === 'zh' ? proj.name : proj.nameEn }}</h4>
                  <div class="flex items-center gap-1.5 mt-1.5">
                    <span v-if="proj.status" class="px-1.5 py-0.5 text-[10px] rounded-full border border-gray-200 dark:border-gray-700 text-muted-foreground">{{ proj.status }}</span>
                    <i v-if="proj.link" class="ri-external-link-line text-[10px] text-brand-purple"></i>
                  </div>
                </button>
              </div>
            </div>
          </div>

          <!-- === USER MESSAGE === -->
          <div v-else-if="msg.type === 'user'" class="chat-msg flex gap-3 justify-end">
            <div class="max-w-[75%]">
              <div class="bg-gradient-brand rounded-2xl rounded-tr-sm px-5 py-3 shadow-glow">
                <p class="text-sm text-white leading-relaxed">{{ msg.content }}</p>
              </div>
              <span class="text-xs text-muted-foreground mt-1 block text-right">{{ locale === 'zh' ? '刚刚' : 'Just now' }}</span>
            </div>
          </div>

          <!-- === AI REPLY === -->
          <div v-else-if="msg.type === 'ai'" class="chat-msg flex gap-3">
            <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
              <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
            </div>
            <div class="flex-1 max-w-2xl">
              <div class="inline-block bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm px-5 py-4 shadow-card border border-white/50 dark:border-gray-700/50">
                <p class="text-sm text-foreground leading-relaxed whitespace-pre-line" v-html="formatMd(msg.content)"></p>
              </div>
              <span class="text-xs text-muted-foreground mt-1 block">{{ locale === 'zh' ? '刚刚' : 'Just now' }}</span>
            </div>
          </div>

        </template>

        <!-- Typing indicator -->
        <div v-if="isTyping" class="flex gap-3">
          <div class="w-8 h-8 rounded-full flex-shrink-0 overflow-hidden mt-1">
            <img src="/sources/rendashi.jpeg" alt="Ren" class="w-full h-full object-cover" />
          </div>
          <div class="bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm rounded-2xl rounded-tl-sm px-5 py-3 shadow-card border border-white/50 dark:border-gray-700/50">
            <div class="typing-indicator">
              <span class="typing-dot"></span>
              <span class="typing-dot"></span>
              <span class="typing-dot"></span>
            </div>
          </div>
        </div>

        <!-- Footer in chat -->
        <div v-if="visibleMessages.length >= allMessages.length" class="chat-msg pt-8 pb-4">
          <div class="flex flex-col items-center gap-4 w-full">
            <div class="w-full border-t border-gray-200/50 dark:border-gray-700/50 pt-8"></div>
            <img :src="isDark ? '/sources/logonight.png' : '/sources/logo3@2x.png'" alt="CBIT" class="h-10 opacity-60" />
            <div class="flex items-center gap-6">
              <div class="flex flex-col items-center gap-2">
                <img src="/sources/xiaohongshu-qr.png" alt="小红书" class="w-24 h-24 rounded-xl shadow-card border border-gray-200/50 dark:border-gray-700/50" />
                <span class="text-xs text-muted-foreground flex items-center gap-1">
                  <i class="ri-red-packet-line text-red-500"></i>{{ locale === 'zh' ? '小红书' : 'Xiaohongshu' }}
                </span>
              </div>
            </div>
            <div class="text-center space-y-1 mt-2">
              <p class="text-xs text-muted-foreground">© {{ new Date().getFullYear() }} CBIT Research Center · {{ locale === 'zh' ? '石仁达个人主页' : 'Ren Shi Profile' }}</p>
              <div class="flex items-center justify-center gap-3">
                <a href="mailto:renshi@cuhk.edu.cn" class="text-xs text-muted-foreground hover:text-brand-purple transition-colors">renshi@cuhk.edu.cn</a>
                <a href="https://github.com/reneverland" target="_blank" class="text-xs text-muted-foreground hover:text-brand-purple transition-colors">GitHub</a>
                <a href="/" class="text-xs text-muted-foreground hover:text-brand-purple transition-colors">{{ locale === 'zh' ? '返回主页' : 'Home' }}</a>
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>

    <!-- Input Bar -->
    <div class="sticky bottom-0 z-40 backdrop-blur-xl bg-white/80 dark:bg-gray-900/80 border-t border-gray-200/50 dark:border-gray-700/50">
      <div class="max-w-4xl mx-auto px-4 sm:px-6 py-3">
        <div class="flex gap-3">
          <input v-model="userInput" type="text"
            :placeholder="t('profile.inputPlaceholder')"
            class="flex-1 px-4 py-3 rounded-xl bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-sm placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-brand-purple/30 transition-all"
            @keydown.enter="sendMessage" :disabled="isLoading" />
          <button @click="sendMessage"
            class="w-11 h-11 rounded-xl bg-gradient-brand hover:opacity-90 shadow-glow flex items-center justify-center transition-all flex-shrink-0"
            :disabled="isLoading || !userInput.trim()">
            <i class="ri-send-plane-fill text-white"></i>
          </button>
        </div>
        <div class="flex items-center gap-2 mt-2">
          <span class="px-2.5 py-1 text-[10px] font-semibold rounded-full bg-gradient-brand text-white tracking-wide flex items-center gap-1">
            <i class="ri-sparkling-line"></i>CBIT-Elite 4.5
          </span>
          <button v-for="q in quickQuestions" :key="q" @click="sendQuickQuestion(q)"
            class="px-3 py-1.5 text-xs font-medium text-brand-purple bg-brand-purple-light/50 dark:bg-brand-purple/20 rounded-full hover:bg-brand-purple-light dark:hover:bg-brand-purple/30 transition-colors">
            {{ q }}
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- ═══ Project Detail Overlay ═══ -->
  <Teleport to="body">
    <transition name="project-overlay">
      <div v-if="selectedProject !== null" class="fixed inset-0 z-[9990] flex" @click.self="selectedProject = null">
        <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" @click="selectedProject = null" />
        <div class="relative ml-auto w-full max-w-2xl h-full bg-white dark:bg-gray-900 shadow-2xl overflow-y-auto">
          <button @click="selectedProject = null"
            class="sticky top-4 right-4 float-right z-10 w-10 h-10 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors mr-4 mt-4">
            <i class="ri-close-line text-foreground text-lg"></i>
          </button>
          <div v-if="selectedProject !== null" class="clear-both">
            <div :class="`relative min-h-[280px] bg-gradient-to-br ${projects[selectedProject].color} p-8 flex flex-col justify-end`">
              <div class="absolute inset-0 opacity-20" style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 32px 32px" />
              <div class="relative z-10 mb-4">
                <span v-if="projects[selectedProject].status" class="px-3 py-1 rounded-full bg-white/20 text-white text-xs font-medium backdrop-blur-sm">{{ projects[selectedProject].status }}</span>
              </div>
              <div class="relative z-10 text-white">
                <div class="w-14 h-14 rounded-2xl bg-white/20 backdrop-blur-sm flex items-center justify-center mb-4 text-white text-2xl font-bold">{{ projects[selectedProject].icon }}</div>
                <h2 class="font-display text-3xl font-bold mb-2">{{ locale === 'zh' ? projects[selectedProject].name : projects[selectedProject].nameEn }}</h2>
                <p class="text-white/80 text-lg">{{ projects[selectedProject].description }}</p>
              </div>
            </div>
            <div class="p-8">
              <p class="text-muted-foreground leading-relaxed mb-6 text-base">{{ locale === 'zh' ? projects[selectedProject].descriptionFull : projects[selectedProject].descriptionFullEn }}</p>
              <div v-if="projects[selectedProject].features" class="mb-6">
                <h4 class="font-display font-semibold text-foreground mb-3">{{ locale === 'zh' ? '核心功能' : 'Key Features' }}</h4>
                <div class="space-y-2">
                  <div v-for="(f, i) in projects[selectedProject].features" :key="i" class="flex items-start gap-2">
                    <i class="ri-checkbox-circle-line text-brand-purple flex-shrink-0 mt-0.5"></i>
                    <span class="text-sm text-muted-foreground">{{ f }}</span>
                  </div>
                </div>
              </div>
              <div v-if="projects[selectedProject].tech?.length" class="mb-6">
                <h4 class="font-display font-semibold text-foreground mb-3">{{ locale === 'zh' ? '技术栈' : 'Tech Stack' }}</h4>
                <div class="flex flex-wrap gap-2">
                  <span v-for="(tech, i) in projects[selectedProject].tech" :key="i" class="px-3 py-1 text-xs rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 text-brand-purple-dark dark:text-brand-purple-light font-medium">{{ tech }}</span>
                </div>
              </div>
              <a v-if="projects[selectedProject].link" :href="projects[selectedProject].link" target="_blank"
                class="inline-flex items-center gap-2 px-6 py-3 rounded-full bg-gradient-brand text-white font-medium hover:opacity-90 shadow-glow transition-all">
                <i class="ri-external-link-line"></i>{{ locale === 'zh' ? '访问项目' : 'Visit Project' }}
              </a>
            </div>
          </div>
        </div>
      </div>
    </transition>
  </Teleport>

  <!-- Avatar Modal -->
  <Teleport to="body">
    <div v-if="showAvatarModal" class="fixed inset-0 z-[9999] flex items-center justify-center bg-black/70 backdrop-blur-sm" @click="showAvatarModal = false">
      <div class="relative max-w-4xl max-h-[90vh] p-4">
        <button @click="showAvatarModal = false" class="absolute top-6 right-6 w-10 h-10 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center hover:bg-white/40 transition-colors z-10">
          <i class="ri-close-line text-white text-xl"></i>
        </button>
        <img src="/sources/rendashi.jpeg" alt="Ren Shi" class="max-w-full max-h-[90vh] rounded-3xl shadow-2xl" @click.stop>
      </div>
    </div>
  </Teleport>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { renProfileAPI } from './services/renprofile-api.js'
import { i18n } from './locales/index.js'

const isDark = ref(true)
const locale = ref('zh')
const showAvatarModal = ref(false)
const userInput = ref('')
const isLoading = ref(false)
const isTyping = ref(false)
const selectedProject = ref(null)
const chatAreaRef = ref(null)

const toggleTheme = () => { isDark.value = !isDark.value }
const toggleLocale = () => { locale.value = locale.value === 'zh' ? 'en' : 'zh' }

watch(isDark, (v) => { document.body.classList.toggle('dark', v) }, { immediate: true })

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[locale.value]
  for (const k of keys) { value = value?.[k] }
  return value || key
})

const formatMd = (text) => {
  return text
    .replace(/\[([^\]]+)\]\(([^)]+)\)/g, (_, txt, url) => {
      const ext = url.startsWith('http') ? ' target="_blank"' : ''
      return `<a href="${url}" class="text-brand-purple hover:underline"${ext}>${txt}</a>`
    })
    .replace(/\*\*(.*?)\*\*/g, '<strong class="text-foreground font-semibold">$1</strong>')
    .replace(/\n/g, '<br>')
}

const formatWorkContent = () => {
  const raw = t.value('profile.workExperience')
  const cleaned = raw
    .replace(/^\*\*工作经历\*\*\n+/, '')
    .replace(/^\*\*Work Experience\*\*\n+/, '')
    .replace(/^\*\*2022[^*]*\*\*\n+/, '')
  return formatMd(cleaned)
}

const quickQuestions = computed(() => [
  t.value('profile.quickQuestions.experience'),
  t.value('profile.quickQuestions.projects'),
  t.value('profile.quickQuestions.teaching'),
])

const educationData = computed(() => [
  { degree: 'MMS', school: 'Duke University', field: locale.value === 'zh' ? '管理学' : 'Management', color: 'from-brand-purple to-brand-blue', icon: 'ri-graduation-cap-line' },
  { degree: 'MS', school: 'NC State University', field: locale.value === 'zh' ? '金融工程' : 'Financial Engineering', color: 'from-blue-500 to-cyan-500', icon: 'ri-bar-chart-box-line' },
  { degree: 'BS', school: 'NC State University', field: locale.value === 'zh' ? '计算机科学 & 数学' : 'CS & Math', color: 'from-emerald-500 to-teal-500', icon: 'ri-code-s-slash-line' },
])

const teachingHighlights = computed(() => locale.value === 'zh' ? [
  '基础编程：变量、条件语句、循环、列表推导式、lambda、类继承',
  '数据整理：处理混乱数据，日期格式与字符串格式问题',
  '数据可视化：matplotlib 和 seaborn',
  '面向对象编程：可重用和模块化组件',
  'AI 进阶：LLM RAG 检索增强生成 & GPT 提示技术',
] : [
  'Foundational Programming: variables, conditionals, loops, comprehensions, lambda, inheritance',
  'Data Munging: messy data, inconsistent date/string formats',
  'Data Visualization: matplotlib and seaborn',
  'OOP: reusable, modular components',
  'Advanced AI: LLM RAG & GPT Prompt Techniques',
])

const researchAreas = computed(() => [
  { icon: 'ri-group-line', label: locale.value === 'zh' ? '多智能体协作' : 'Multi-Agent Collaboration' },
  { icon: 'ri-settings-4-line', label: locale.value === 'zh' ? '大模型微调' : 'LLM Fine-tuning' },
  { icon: 'ri-global-line', label: 'AI & Society' },
])

const patents = computed(() => [
  { title: locale.value === 'zh' ? '基于向量数据库的智能问答算法' : 'Intelligent Q&A Algorithm Based on Vector Database', number: 'CN202410462708.2' },
  { title: locale.value === 'zh' ? '基于时空语义聚类与大语言模型的政务工单智能处理方法及系统' : 'Intelligent Processing of Government Work Orders via Spatiotemporal Semantic Clustering & LLM', number: '2025 1 1333257.3' },
])

const papers = computed(() => [
  { title: 'Memory-Enhanced Artificial Rabbits Optimization for Solving Global Optimization and Feature Selection', venue: 'Working Paper' },
  { title: 'Test-driven Repository Abstraction for Code Engineering & Refinement', venue: 'Working Paper' },
])

const projects = computed(() => [
  { icon: 'A', name: 'AiExam-plus AI智能考核平台', nameEn: 'AiExam-plus AI Assessment', description: locale.value === 'zh' ? '智能化考核与评估系统' : 'Intelligent assessment system', descriptionFull: locale.value === 'zh' ? '智能化考核与评估系统，支持自动化评分与反馈。' : 'Intelligent assessment and evaluation system with automated scoring and feedback.', descriptionFullEn: 'Intelligent assessment and evaluation system with automated scoring and feedback.', color: 'from-brand-purple to-brand-blue', link: 'http://www.llmhi.com:9000', status: locale.value === 'zh' ? '已上线' : 'Online', features: locale.value === 'zh' ? ['智能出题与评分', '自动反馈生成', '多维度考核分析'] : ['Smart question generation & grading', 'Auto feedback generation', 'Multi-dimensional assessment'], tech: ['LLM', 'RAG', 'Vue', 'FastAPI'] },
  { icon: '电', name: '中电一所AI电子档案管理', nameEn: 'CETC AI Archive Management', description: locale.value === 'zh' ? '驻点项目 - AI智能档案管理系统' : 'On-site AI archive management', descriptionFull: locale.value === 'zh' ? '为大型制造业单位构建电子档案规范化系统，实现档案数字化 → 规范提取 → 结构化入库 → 可视化检索。' : 'Standardized e-archive system for manufacturing with digitization, structured storage, and visual retrieval.', descriptionFullEn: 'Standardized e-archive system for manufacturing with digitization, structured storage, and visual retrieval.', color: 'from-violet-500 to-purple-500', status: locale.value === 'zh' ? '驻点' : 'On-site', features: locale.value === 'zh' ? ['电子档案扫描文本提取', 'OCR + 内容解析一体化', '合规性校验与流程标准化', '秒级档案检索'] : ['E-archive scanning & text extraction', 'Integrated OCR + content parsing', 'Compliance verification', 'Sub-second search'], tech: ['OCR + NLP', 'LLM Parsing', 'Vector Retrieval', 'Knowledge Graph'] },
  { icon: '港', name: '香港中文大学(深圳) AI智能助手', nameEn: 'CUHK-SZ AI Assistant', description: locale.value === 'zh' ? '校园智能问答助手' : 'Campus Q&A assistant', descriptionFull: locale.value === 'zh' ? '为研究生招生、教务、政策咨询提供智能化回答系统，实现信息发布自动化、FAQ智能匹配与流程指引。' : 'Smart Q&A for graduate admissions, academic affairs, and policy consultation.', descriptionFullEn: 'Intelligent Q&A system for graduate admissions, academic affairs, and policy consultation.', color: 'from-blue-500 to-cyan-500', link: 'https://gptsme.com', status: locale.value === 'zh' ? '已上线' : 'Online', features: locale.value === 'zh' ? ['Q&A 智能助手', '学院知识库构建', 'LLM + RAG 智能体系'] : ['Q&A AI Assistant', 'Knowledge base construction', 'LLM + RAG system'], tech: ['Qwen', 'LLM Fine-tuning', 'Qdrant', 'RAG'] },
  { icon: 'G', name: '广东以色列理工学院 AI招生助手', nameEn: 'GTIIT AI Admissions Assistant', description: locale.value === 'zh' ? '为GTIIT提供的智能招生问答助手' : 'AI admissions assistant for GTIIT', descriptionFull: locale.value === 'zh' ? '人工智能驱动的招生问答、政策解释与招生策略推荐系统。' : 'AI-driven admissions Q&A and strategy recommendation.', descriptionFullEn: 'AI-driven admissions Q&A, policy interpretation, and strategy recommendation system.', color: 'from-emerald-500 to-teal-500', link: 'http://llmhi.com:9400', status: locale.value === 'zh' ? '已上线' : 'Online', features: locale.value === 'zh' ? ['招生政策问答', '招生流程指引', '国际办学体系FAQ', '招生材料自动校验'] : ['Admissions Policy Q&A', 'Process Guidance', 'International Education FAQ', 'Auto Material Verification'], tech: ['LLM Q&A', 'Multi-KB Routing', 'Vector Retrieval'] },
  { icon: 'S', name: '广东以色列理工学院智能奖学金申请平台', nameEn: 'GTIIT Smart Scholarship Platform', description: locale.value === 'zh' ? 'GTIIT智能奖学金申请与评审平台' : 'Smart scholarship application platform', descriptionFull: locale.value === 'zh' ? '为广东以色列理工学院提供智能化奖学金申请、评审与管理平台。' : 'Intelligent scholarship application, review, and management platform for GTIIT.', descriptionFullEn: 'Intelligent scholarship application, review, and management platform for GTIIT.', color: 'from-teal-500 to-cyan-500', link: 'https://gtiitscholar.com', status: locale.value === 'zh' ? '已上线' : 'Online', features: locale.value === 'zh' ? ['在线奖学金申请', '智能材料审核', '申请进度追踪', '多维度评审系统'] : ['Online scholarship application', 'Smart material review', 'Application tracking', 'Multi-dimensional evaluation'], tech: ['LLM', 'RAG', 'Vue', 'FastAPI'] },
  { icon: 'V', name: 'VoxChina 生成式科研平台', nameEn: 'VoxChina Generative Research', description: locale.value === 'zh' ? '生成式AI科研协作平台' : 'Generative AI research platform', descriptionFull: locale.value === 'zh' ? '搭建文章摘要、多篇聚合摘要、语音播报和知识问答的 AI 内容平台。' : 'AI content platform for summarization and knowledge Q&A.', descriptionFullEn: 'AI content platform for article summarization, voice broadcast, and knowledge Q&A.', color: 'from-orange-500 to-amber-500', link: 'http://llmhi.com:8400', status: locale.value === 'zh' ? '开发中' : 'In Dev', features: locale.value === 'zh' ? ['文章智能摘要', '多篇聚合分析', '语音播报系统', '知识问答引擎'] : ['Smart article summarization', 'Multi-article aggregation', 'Voice broadcast', 'Knowledge Q&A engine'], tech: ['Qwen', 'Whisper', 'Qdrant', 'RAG'] },
  { icon: '江', name: '江招智能招标审核系统', nameEn: 'JiangZhao Smart Bidding', description: locale.value === 'zh' ? 'AI驱动的智能招标审核系统' : 'AI-driven bidding review', descriptionFull: locale.value === 'zh' ? '实现招标文件的自动解析、条款核验、风险提示与合规轨迹可视化。' : 'Automated bid parsing, clause verification, risk alerts, and compliance visualization.', descriptionFullEn: 'Automated bid document parsing, clause verification, risk alerts, and compliance visualization.', color: 'from-emerald-500 to-green-500', link: 'http://llmhi.com:7300/', status: locale.value === 'zh' ? '开发中' : 'In Dev', features: locale.value === 'zh' ? ['招标文件自动解析', '条款核验与风险提示', '合规轨迹可视化', '智能审核报告生成'] : ['Auto bid parsing', 'Clause verification & risk alerts', 'Compliance visualization', 'Smart audit reports'], tech: ['多模型验证审核 Multi-Model Verification'], patentPending: true },
  { icon: '学', name: '深圳学徒平台', nameEn: 'SZ Apprentice Platform', description: locale.value === 'zh' ? '深圳学徒培养与管理平台' : 'Apprentice training platform', descriptionFull: locale.value === 'zh' ? '深圳学徒培养与管理平台。' : 'Shenzhen apprentice training and management platform.', descriptionFullEn: 'Shenzhen apprentice training and management platform.', color: 'from-sky-500 to-blue-500' },
  { icon: 'C', name: 'CBIT×百度真人生成模型', nameEn: 'CBIT×Baidu Person Gen', description: locale.value === 'zh' ? '与百度合作的真人生成模型' : 'Real person generation with Baidu', descriptionFull: locale.value === 'zh' ? 'CBIT与百度深圳Design Team合作的真人生成模型，构建城市场景图像智能生成系统。' : 'Urban scene image generation with Baidu Shenzhen Design Team.', descriptionFullEn: 'Real person generation model with Baidu for urban scene image generation.', color: 'from-pink-500 to-rose-500', status: locale.value === 'zh' ? '已完成' : 'Completed', features: locale.value === 'zh' ? ['文生图场景生成', '语义一致性检验', '可控生成技术', '城市场景定制化'] : ['Text-to-image generation', 'Semantic consistency', 'Controllable generation', 'Urban scene customization'], tech: ['ComfyUI', 'SDXL', 'ControlNet', 'Qwen3-Coder'] },
  { icon: '联', name: 'CBIT即时联网大模型 3.3', nameEn: 'CBIT Real-time Internet LLM', description: locale.value === 'zh' ? '具备实时联网能力的大语言模型' : 'LLM with real-time internet', descriptionFull: locale.value === 'zh' ? '具备实时联网能力的大语言模型。' : 'Large language model with real-time internet connectivity.', descriptionFullEn: 'Large language model with real-time internet connectivity.', color: 'from-indigo-500 to-violet-500' },
  { icon: 'I', name: 'IMBA小程序', nameEn: 'IMBA Mini Program', description: locale.value === 'zh' ? 'IMBA项目专属小程序' : 'Dedicated mini program for IMBA', descriptionFull: locale.value === 'zh' ? 'IMBA项目专属小程序应用。' : 'Dedicated mini program application for IMBA project.', descriptionFullEn: 'Dedicated mini program application for IMBA project.', color: 'from-teal-500 to-emerald-500' },
])

const openProject = (i) => { selectedProject.value = i }

// ─── Message sequence ───
const allMessages = [
  { id: 'welcome', type: 'welcome' },
  { id: 'edu', type: 'education' },
  { id: 'work', type: 'work' },
  { id: 'teaching', type: 'teaching' },
  { id: 'research', type: 'research' },
  { id: 'patents', type: 'patents' },
  { id: 'papers', type: 'papers' },
  { id: 'projects', type: 'projects' },
]

const visibleMessages = ref([])
const dynamicMessages = ref([])
let msgIdCounter = 100

const scrollToBottom = () => {
  nextTick(() => {
    if (chatAreaRef.value) {
      chatAreaRef.value.scrollTo({ top: chatAreaRef.value.scrollHeight, behavior: 'smooth' })
    }
  })
}

const sendMessage = async () => {
  const text = userInput.value.trim()
  if (!text || isLoading.value) return

  const userMsg = { id: msgIdCounter++, type: 'user', content: text }
  visibleMessages.value.push(userMsg)
  dynamicMessages.value.push(userMsg)
  userInput.value = ''
  scrollToBottom()

  isLoading.value = true
  isTyping.value = true
  scrollToBottom()

  try {
    const history = dynamicMessages.value
      .filter(m => m.type === 'user' || m.type === 'ai')
      .slice(-10)
      .map(m => ({ role: m.type === 'user' ? 'user' : 'assistant', content: m.content }))

    const response = await renProfileAPI.sendMessage(history)
    isTyping.value = false

    const fallbackZh = '感谢您的提问！您可以询问我关于工作经历、教学、教育背景、研究兴趣、专利或 AI 项目的问题。'
    const fallbackEn = 'Thanks for your question! Ask about work, teaching, education, research, patents, or AI projects.'
    let aiResponse = locale.value === 'zh' ? fallbackZh : fallbackEn

    if (response.choices?.[0]) {
      const firstChoice = response.choices[0]
      const content = firstChoice.message?.content?.trim() || ''
      if (firstChoice.message?.metadata?.needs_confirmation) {
        const suggestions = response.cbit_metadata?.suggested_questions || []
        const best = suggestions[0]
        if (best && best.similarity >= 0.75) {
          try {
            const confirmData = await renProfileAPI.sendCustomRequest({
              messages: [{ role: 'user', content: text }],
              inputs: {}, response_mode: 'blocking', conversation_id: '', user: 'web-user', files: [], selected_qa_id: best.qa_id
            })
            const answer = confirmData.choices?.[0]?.message?.content?.trim()
            if (answer) aiResponse = answer
          } catch { /* fallback */ }
        }
      } else if (content && !(content.includes('根据知识库内容') && content.length < 50)) {
        aiResponse = content
      }
    } else if (response.answer?.trim()) {
      aiResponse = response.answer
    }

    const aiMsg = { id: msgIdCounter++, type: 'ai', content: aiResponse }
    visibleMessages.value.push(aiMsg)
    dynamicMessages.value.push(aiMsg)
    scrollToBottom()
  } catch {
    isTyping.value = false
    const errMsg = { id: msgIdCounter++, type: 'ai', content: locale.value === 'zh' ? '抱歉，连接服务器时出现问题，请稍后再试。' : 'Sorry, server issue. Please try again later.' }
    visibleMessages.value.push(errMsg)
    dynamicMessages.value.push(errMsg)
    scrollToBottom()
  } finally {
    isLoading.value = false
  }
}

const sendQuickQuestion = (q) => {
  userInput.value = q
  sendMessage()
}

onMounted(() => {
  const delays = [300, 1200, 2200, 3200, 4000, 4800, 5600, 6400]
  allMessages.forEach((msg, i) => {
    setTimeout(() => {
      isTyping.value = true
      scrollToBottom()
      setTimeout(() => {
        visibleMessages.value.push(msg)
        isTyping.value = i < allMessages.length - 1
        scrollToBottom()
      }, 500)
    }, delays[i])
  })
})
</script>

<style>
body:has(.dark.main-page-container) {
  background: rgb(17, 24, 39) !important;
}

.chat-msg {
  animation: msg-in 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}
@keyframes msg-in {
  from { opacity: 0; transform: translateY(16px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-20px); }
}
.animate-float { animation: float 6s ease-in-out infinite; }

.patent-badge { animation: patent-glow 2s ease-in-out infinite; }
@keyframes patent-glow {
  0%, 100% { box-shadow: 0 0 4px rgba(217, 119, 6, 0.2); }
  50% { box-shadow: 0 0 12px rgba(217, 119, 6, 0.4); }
}

.project-overlay-enter-active,
.project-overlay-leave-active {
  transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}
.project-overlay-enter-active > div:last-child,
.project-overlay-leave-active > div:last-child {
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}
.project-overlay-enter-from,
.project-overlay-leave-to {
  opacity: 0;
}
.project-overlay-enter-from > div:last-child,
.project-overlay-leave-to > div:last-child {
  transform: translateX(100%);
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>


