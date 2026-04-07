<template>
  <section ref="sectionRef" class="relative py-24 lg:py-32 overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-white via-brand-purple-light/10 to-white dark:from-gray-900 dark:via-gray-800/10 dark:to-gray-900" />

    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="text-center mb-16">
        <div class="project-title inline-flex items-center gap-2 px-4 py-2 rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 border border-brand-purple/20 mb-6">
          <i class="ri-folder-open-line text-brand-purple"></i>
          <span class="text-sm font-medium text-brand-purple-dark dark:text-brand-purple-light">{{ t('proj.badge') }}</span>
        </div>
        <h2 class="project-title font-display text-4xl sm:text-5xl font-bold text-foreground mb-4">
          {{ t('proj.title') }}<span class="text-gradient">{{ t('proj.titleHighlight') }}</span>
        </h2>
        <p class="project-title text-lg text-muted-foreground max-w-2xl mx-auto">{{ t('proj.subtitle') }}</p>
      </div>

      <!-- Featured Project -->
      <div class="mb-12">
        <div class="relative rounded-3xl overflow-hidden bg-white dark:bg-gray-800 border border-gray-200/50 dark:border-gray-700/50 shadow-card-hover">
          <div :class="`h-2 bg-gradient-to-r ${projects[activeProject].color}`" />
          <div class="grid lg:grid-cols-2">
            <div :class="`relative min-h-[300px] lg:min-h-[400px] bg-gradient-to-br ${projects[activeProject].color} p-8 flex flex-col justify-between`">
              <div class="absolute inset-0 opacity-20" style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 32px 32px" />
              <div class="relative z-10">
                <div class="flex items-center gap-3 mb-4">
                  <span class="px-3 py-1 rounded-full bg-white/20 text-white text-xs font-medium backdrop-blur-sm">{{ projects[activeProject].status }}</span>
                  <span class="text-sm text-white/80">{{ projects[activeProject].period }}</span>
                </div>
                <div class="w-16 h-16 rounded-2xl bg-white/20 backdrop-blur-sm flex items-center justify-center mb-6">
                  <i :class="projects[activeProject].icon" class="text-white text-3xl"></i>
                </div>
              </div>
              <div class="relative z-10 text-white">
                <h3 class="font-display text-2xl lg:text-3xl font-bold mb-2">{{ projects[activeProject].title }}</h3>
                <p class="text-white/80">{{ projects[activeProject].subtitle }}</p>
              </div>
            </div>
            <div class="p-8 lg:p-10">
              <p class="text-muted-foreground leading-relaxed mb-6">{{ projects[activeProject].description }}</p>
              <div class="space-y-3 mb-6">
                <h4 class="font-medium text-foreground">{{ t('proj.features') }}</h4>
                <div v-for="(f, idx) in projects[activeProject].features" :key="idx" class="flex items-start gap-2">
                  <i class="ri-checkbox-circle-line text-brand-purple flex-shrink-0 mt-0.5"></i>
                  <span class="text-sm text-muted-foreground">{{ f }}</span>
                </div>
              </div>
              <div class="mb-6">
                <h4 class="font-medium text-foreground mb-3">{{ t('proj.techStack') }}</h4>
                <div class="flex flex-wrap gap-2 items-center">
                  <span v-for="(tech, idx) in projects[activeProject].tech" :key="idx" class="px-3 py-1 text-xs rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 text-brand-purple-dark dark:text-brand-purple-light font-medium">{{ tech }}</span>
                  <span v-if="projects[activeProject].patentPending" class="patent-badge px-3 py-1 text-xs rounded-full bg-amber-100 dark:bg-amber-900/30 text-amber-700 dark:text-amber-400 font-semibold border border-amber-300 dark:border-amber-700 flex items-center gap-1.5">
                    <i class="ri-shield-check-line"></i>{{ locale === 'zh' ? '专利申请中' : 'Patent Pending' }}
                  </span>
                </div>
              </div>
              <a v-if="projects[activeProject].link" :href="projects[activeProject].link" target="_blank"
                class="inline-flex items-center gap-2 px-5 py-2.5 rounded-full bg-gradient-brand text-white text-sm font-medium hover:opacity-90 shadow-glow">
                <i class="ri-external-link-line"></i>{{ t('proj.learnMore') }}
              </a>
            </div>
          </div>
        </div>
      </div>

      <!-- Project Cards -->
      <div ref="cardsRef" class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
        <button v-for="(project, index) in projects" :key="project.id" @click="activeProject = index"
          class="project-card text-left p-5 rounded-2xl border transition-all duration-300"
          :class="activeProject === index ? 'bg-brand-purple-light/30 dark:bg-brand-purple/10 border-brand-purple/30 shadow-card' : 'bg-white dark:bg-gray-800 border-gray-200/50 dark:border-gray-700/50 shadow-card hover:shadow-card-hover hover:-translate-y-1'">
          <div :class="`w-10 h-10 rounded-xl bg-gradient-to-br ${project.color} flex items-center justify-center mb-4`">
            <i :class="project.icon" class="text-white text-lg"></i>
          </div>
          <h4 :class="`font-display font-semibold text-sm mb-1 line-clamp-2 ${activeProject === index ? 'text-brand-purple' : 'text-foreground'}`">{{ project.title }}</h4>
          <p class="text-xs text-muted-foreground mb-3">{{ project.subtitle }}</p>
          <div class="flex items-center gap-2">
            <span class="px-2 py-0.5 text-xs rounded-full border border-gray-200 dark:border-gray-700 text-muted-foreground">{{ project.status }}</span>
            <span class="text-xs text-muted-foreground">{{ project.period }}</span>
          </div>
        </button>
      </div>

      <div class="mt-16 text-center">
        <div class="inline-flex flex-col sm:flex-row items-center gap-4 p-6 rounded-3xl bg-gradient-to-r from-brand-purple-light/30 to-blue-50/20 dark:from-brand-purple/10 dark:to-gray-800 border border-brand-purple/20">
          <div class="flex items-center gap-3">
            <div class="w-12 h-12 rounded-full bg-gradient-brand flex items-center justify-center">
              <i class="ri-cpu-line text-white text-xl"></i>
            </div>
            <div class="text-left">
              <h4 class="font-display font-semibold text-foreground">{{ t('proj.collabTitle') }}</h4>
              <p class="text-sm text-muted-foreground">{{ t('proj.collabDesc') }}</p>
            </div>
          </div>
          <a href="mailto:renshi@cuhk.edu.cn" class="px-5 py-2.5 rounded-full bg-gradient-brand text-white text-sm font-medium hover:opacity-90 shadow-glow whitespace-nowrap flex items-center gap-2">
            <i class="ri-database-2-line"></i>{{ t('proj.collabBtn') }}
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
const cardsRef = ref(null)
const activeProject = ref(0)

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) { value = value?.[k] }
  return value || key
})

const projects = computed(() => [
  {
    id: 5, icon: 'ri-file-shield-2-line', color: 'from-emerald-500 to-teal-500',
    title: props.locale === 'zh' ? '江招招标文件智能核验平台' : 'Jiangzhao Smart Bid Verification Platform',
    subtitle: 'Smart Bid Verification', period: '2025 – 2026',
    status: t.value('proj.ongoing'),
    link: 'http://llmhi.com:7300/',
    description: props.locale === 'zh' ? '实现招标文件的自动解析、条款核验、风险提示与合规轨迹可视化。' : 'Automated bid document parsing, clause verification, risk alerts, and compliance visualization.',
    features: props.locale === 'zh' ? ['招标文件自动解析', '条款核验与风险提示', '合规轨迹可视化', '智能审核报告生成'] : ['Automated bid document parsing', 'Clause verification & risk alerts', 'Compliance trace visualization', 'Smart audit report generation'],
    tech: ['多模型验证审核 Multi-Model Verification'],
    patentPending: true,
  },
  {
    id: 1, icon: 'ri-chat-smile-2-line', color: 'from-brand-purple to-brand-blue',
    title: props.locale === 'zh' ? '香港中文大学（深圳）智能招生系统（SME）' : 'CUHK-Shenzhen Smart Admission System (SME)',
    subtitle: 'Smart Admission System', period: '2023 – 2025',
    status: t.value('proj.ongoing'),
    description: props.locale === 'zh' ? '为研究生招生、教务、政策咨询提供智能化回答系统，实现信息发布自动化、FAQ智能匹配与流程指引。' : 'Intelligent Q&A system for graduate admissions, academic affairs, and policy consultation with automated FAQ matching.',
    features: props.locale === 'zh' ? ['Q&A 智能助手（支持复杂政策问答、学费、奖学金、课程）', '学院知识库构建（PDF/网页内容自动抽取）', 'LLM + RAG 智能体系（知识专属、可信回答）'] : ['Q&A AI Assistant (policy, tuition, scholarships, courses)', 'Knowledge base construction (PDF/webpage auto extraction)', 'LLM + RAG system (knowledge-specific, reliable answers)'],
    tech: ['Qwen', 'LLM Fine-tuning', 'Qdrant', 'RAG', 'Policy Parsing'],
  },
  {
    id: 2, icon: 'ri-search-eye-line', color: 'from-blue-500 to-cyan-500',
    title: props.locale === 'zh' ? '广东以色列理工学院（GTIIT）招生 AI 系统' : 'GTIIT AI Admission System',
    subtitle: 'GTIIT AI Admission', period: '2025 –',
    status: t.value('proj.ongoing'),
    description: props.locale === 'zh' ? '人工智能驱动的招生问答、政策解释与招生策略推荐系统。' : 'AI-driven admissions Q&A, policy interpretation, and strategy recommendation system.',
    features: props.locale === 'zh' ? ['招生政策问答', '招生流程指引', '国际办学体系常见问题解析', '招生材料自动校验（初步版）'] : ['Admissions Policy Q&A', 'Admissions Process Guidance', 'International Education System FAQ', 'Auto Verification of Admission Materials'],
    tech: ['LLM Q&A', 'Multi-KB Routing', 'Vector Retrieval', 'Structured Data Parsing'],
  },
  {
    id: 3, icon: 'ri-archive-stack-line', color: 'from-violet-500 to-purple-500',
    title: props.locale === 'zh' ? '深圳市中电一所智能制造业电子档案项目' : 'Shenzhen CEPREI Smart E-Archive Project',
    subtitle: 'Smart E-Archive', period: '2024 – 2025',
    status: t.value('proj.completed'),
    description: props.locale === 'zh' ? '为大型制造业单位构建电子档案规范化系统，实现档案数字化 → 规范提取 → 结构化入库 → 可视化检索。' : 'Standardized e-archive system for manufacturing with digitization, structured storage, and visual retrieval.',
    features: props.locale === 'zh' ? ['完成电子档案扫描文本提取', '研制 OCR + 内容解析一体化模块', '提供合规性校验与流程标准化', '大幅提升档案检索效率（秒级搜索）'] : ['E-archive scanning and text extraction', 'Integrated OCR + content parsing module', 'Compliance verification and process standardization', 'Sub-second search efficiency'],
    tech: ['OCR + NLP', 'LLM Parsing', 'Vector Retrieval', 'Knowledge Graph'],
  },
  {
    id: 4, icon: 'ri-article-line', color: 'from-orange-500 to-amber-500',
    title: props.locale === 'zh' ? 'VoxChina 内容智能化平台' : 'VoxChina Intelligent Content Platform',
    subtitle: 'VoxChina AI Content', period: '2025 – 2026',
    status: t.value('proj.ongoing'),
    description: props.locale === 'zh' ? '搭建文章摘要、多篇聚合摘要、语音播报和知识问答的 AI 内容平台。' : 'AI content platform for article summarization, multi-article aggregation, voice broadcast, and knowledge Q&A.',
    features: props.locale === 'zh' ? ['文章智能摘要', '多篇聚合分析', '语音播报系统', '知识问答引擎'] : ['Smart article summarization', 'Multi-article aggregation', 'Voice broadcast system', 'Knowledge Q&A engine'],
    tech: ['Qwen', 'Whisper', 'Text Summarization', 'Qdrant', 'RAG'],
  },
  {
    id: 6, icon: 'ri-image-ai-line', color: 'from-pink-500 to-rose-500',
    title: props.locale === 'zh' ? '百度深圳图像模态生成项目' : 'Baidu Shenzhen Image Generation Project',
    subtitle: 'Multimodal Image Gen', period: '2025 – 2026',
    status: t.value('proj.ongoing'),
    description: props.locale === 'zh' ? '构建城市场景图像智能生成系统，实现文生图、语义一致性检验与可控生成。' : 'Urban scene image generation system with text-to-image, semantic verification, and controllable generation.',
    features: props.locale === 'zh' ? ['文生图场景生成', '语义一致性检验', '可控生成技术', '城市场景定制化'] : ['Text-to-image generation', 'Semantic consistency verification', 'Controllable generation', 'Urban scene customization'],
    tech: ['ComfyUI', 'SDXL', 'ControlNet', 'Qwen3-Coder', 'GPU A100 Cluster'],
  },
])

onMounted(() => {
  gsap.context(() => {
    gsap.fromTo('.project-title', { opacity: 0, y: 40 }, { opacity: 1, y: 0, duration: 0.8, ease: 'expo.out', scrollTrigger: { trigger: sectionRef.value, start: 'top 70%', toggleActions: 'play none none reverse' } })
    gsap.fromTo(cardsRef.value?.querySelectorAll('.project-card') || [], { opacity: 0, y: 50, scale: 0.95 }, { opacity: 1, y: 0, scale: 1, duration: 0.6, stagger: 0.1, ease: 'expo.out', scrollTrigger: { trigger: cardsRef.value, start: 'top 75%', toggleActions: 'play none none reverse' } })
  }, sectionRef)
})
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.patent-badge {
  animation: patent-glow 2s ease-in-out infinite;
}
@keyframes patent-glow {
  0%, 100% { box-shadow: 0 0 4px rgba(217, 119, 6, 0.2); }
  50% { box-shadow: 0 0 12px rgba(217, 119, 6, 0.4); }
}
</style>
