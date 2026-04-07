<template>
  <section id="team" ref="sectionRef" class="relative py-24 lg:py-32 overflow-hidden">
    <div class="absolute inset-0 bg-gradient-to-b from-white via-brand-purple-light/10 to-white dark:from-gray-900 dark:via-gray-800/10 dark:to-gray-900" />
    <div class="absolute top-1/4 right-0 w-96 h-96 bg-brand-purple/5 rounded-full blur-3xl" />

    <div class="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="text-center mb-16">
        <div class="team-title inline-flex items-center gap-2 px-4 py-2 rounded-full bg-brand-purple-light/50 dark:bg-brand-purple/20 border border-brand-purple/20 mb-6">
          <i class="ri-team-line text-brand-purple"></i>
          <span class="text-sm font-medium text-brand-purple-dark dark:text-brand-purple-light">{{ t('team.badge') }}</span>
        </div>
        <h2 class="team-title font-display text-4xl sm:text-5xl font-bold text-foreground mb-4">
          {{ t('team.title') }}<span class="text-gradient">{{ t('team.titleHighlight') }}</span>
        </h2>
        <p class="team-title text-lg text-muted-foreground max-w-2xl mx-auto">{{ t('team.subtitle') }}</p>
      </div>

      <div ref="gridRef" class="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <div v-for="member in teamMembers" :key="member.name"
          class="team-card group relative rounded-3xl bg-white dark:bg-gray-800 border border-gray-200/50 dark:border-gray-700/50 shadow-card hover:shadow-card-hover transition-all duration-500 overflow-hidden cursor-pointer"
          @click="selectedMember = member">
          <div :class="`h-24 bg-gradient-to-br ${member.color} relative overflow-hidden`">
            <div class="absolute inset-0 opacity-20" style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 24px 24px" />
            <div class="absolute top-4 left-4">
              <span class="px-3 py-1 rounded-full bg-white/20 backdrop-blur-sm text-white text-xs font-medium">{{ member.role }}</span>
            </div>
          </div>
          <div class="relative px-6 -mt-10">
            <div :class="`w-20 h-20 rounded-2xl bg-gradient-to-br ${member.color} p-0.5 shadow-lg group-hover:scale-105 transition-transform duration-500`">
              <img v-if="member.avatar" :src="member.avatar" :alt="member.name" class="w-full h-full rounded-2xl object-cover bg-white" />
              <div v-else class="w-full h-full rounded-2xl bg-white dark:bg-gray-700 flex items-center justify-center">
                <span class="font-display text-2xl font-bold text-gradient">{{ member.name[0] }}</span>
              </div>
            </div>
          </div>
          <div class="p-6 pt-4">
            <h3 class="font-display text-lg font-semibold text-foreground group-hover:text-brand-purple transition-colors">{{ member.name }}</h3>
            <p class="text-sm text-muted-foreground mb-1">{{ member.nameEn }}</p>
            <p class="text-xs text-brand-purple font-medium mb-2">{{ member.title }}</p>
            <p class="text-xs text-muted-foreground mb-4 line-clamp-3">{{ member.expertise }}</p>
            <div class="flex gap-2">
              <a v-if="member.email" :href="`mailto:${member.email}`" @click.stop
                class="w-8 h-8 rounded-full hover:bg-brand-purple-light/50 dark:hover:bg-brand-purple/20 flex items-center justify-center transition-colors">
                <i class="ri-mail-line text-muted-foreground text-sm"></i>
              </a>
              <a v-if="member.links?.website" :href="member.links.website" target="_blank" @click.stop
                class="w-8 h-8 rounded-full hover:bg-brand-purple-light/50 dark:hover:bg-brand-purple/20 flex items-center justify-center transition-colors">
                <i class="ri-link text-muted-foreground text-sm"></i>
              </a>
              <span class="ml-auto text-xs text-brand-purple flex items-center gap-1 cursor-pointer">
                {{ t('team.details') }}<i class="ri-external-link-line text-xs"></i>
              </span>
            </div>
          </div>
        </div>
      </div>

      <div class="mt-16 text-center">
        <div class="inline-flex flex-col sm:flex-row items-center gap-4 p-6 rounded-3xl bg-gradient-to-r from-brand-purple-light/30 to-blue-50/20 dark:from-brand-purple/10 dark:to-gray-800 border border-brand-purple/20">
          <div class="flex items-center gap-3">
            <div class="w-12 h-12 rounded-full bg-gradient-brand flex items-center justify-center">
              <i class="ri-graduation-cap-line text-white text-xl"></i>
            </div>
            <div class="text-left">
              <h4 class="font-display font-semibold text-foreground">{{ t('team.joinTitle') }}</h4>
              <p class="text-sm text-muted-foreground">{{ t('team.joinDesc') }}</p>
            </div>
          </div>
          <a href="mailto:renshi@cuhk.edu.cn" class="px-5 py-2.5 rounded-full bg-gradient-brand text-white text-sm font-medium hover:opacity-90 shadow-glow whitespace-nowrap flex items-center gap-2">
            <i class="ri-award-line"></i>{{ t('team.joinBtn') }}
          </a>
        </div>
      </div>
    </div>

    <!-- Member Detail Dialog -->
    <Teleport to="body">
      <div v-if="selectedMember" class="fixed inset-0 z-[9999] flex items-center justify-center bg-black/60 backdrop-blur-sm" @click="selectedMember = null">
        <div class="relative max-w-lg w-full mx-4 bg-white dark:bg-gray-800 rounded-3xl shadow-2xl overflow-hidden" @click.stop>
          <div :class="`h-32 bg-gradient-to-br ${selectedMember.color} relative overflow-hidden`">
            <div class="absolute inset-0 opacity-20" style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 24px 24px" />
            <button @click="selectedMember = null" class="absolute top-4 right-4 w-8 h-8 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center hover:bg-white/40 transition-colors">
              <i class="ri-close-line text-white"></i>
            </button>
            <div class="absolute bottom-4 left-6">
              <div class="w-20 h-20 rounded-2xl bg-white shadow-lg overflow-hidden">
                <img v-if="selectedMember.avatar" :src="selectedMember.avatar" :alt="selectedMember.name" class="w-full h-full object-cover" />
                <div v-else class="w-full h-full flex items-center justify-center"><span class="font-display text-3xl font-bold text-gradient">{{ selectedMember.name[0] }}</span></div>
              </div>
            </div>
          </div>
          <div class="p-6 pt-4 space-y-4 max-h-[60vh] overflow-y-auto">
            <div>
              <h3 class="font-display text-2xl font-bold text-foreground">{{ selectedMember.name }}</h3>
              <p class="text-muted-foreground">{{ selectedMember.nameEn }} · {{ selectedMember.title }}</p>
            </div>
            <div v-if="selectedMember.expertise">
              <h4 class="text-sm font-medium text-foreground mb-2">{{ t('team.dialogResearch') }}</h4>
              <p class="text-sm text-muted-foreground leading-relaxed">{{ selectedMember.expertise }}</p>
            </div>
            <div v-if="selectedMember.education?.length">
              <h4 class="text-sm font-medium text-foreground mb-2">{{ locale === 'zh' ? '教育背景' : 'Education' }}</h4>
              <div class="space-y-1.5">
                <div v-for="(edu, idx) in selectedMember.education" :key="idx" class="flex items-start gap-2 text-sm text-muted-foreground">
                  <i class="ri-graduation-cap-line text-brand-purple text-xs mt-1 flex-shrink-0"></i>
                  <span><strong class="text-foreground/80">{{ edu.degree }}</strong><span v-if="edu.field"> · {{ edu.field }}</span> — {{ edu.school }}</span>
                </div>
              </div>
            </div>
            <div class="flex gap-3 pt-4">
              <a v-if="selectedMember.email" :href="`mailto:${selectedMember.email}`" class="flex-1 px-4 py-2.5 rounded-full bg-gradient-brand text-white text-sm font-medium text-center hover:opacity-90 flex items-center justify-center gap-2">
                <i class="ri-mail-send-line"></i>{{ t('team.dialogEmail') }}
              </a>
              <a v-if="selectedMember.links?.website" :href="selectedMember.links.website" target="_blank" class="px-4 py-2.5 rounded-full border border-gray-200 dark:border-gray-700 text-sm font-medium hover:bg-gray-50 dark:hover:bg-gray-700 flex items-center gap-2">
                <i class="ri-link"></i>{{ t('team.dialogWebsite') }}
              </a>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
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
const gridRef = ref(null)
const selectedMember = ref(null)

const t = computed(() => (key) => {
  const keys = key.split('.')
  let value = i18n[props.locale]
  for (const k of keys) { value = value?.[k] }
  return value || key
})

const colors = ['from-brand-purple to-brand-blue', 'from-blue-500 to-cyan-500', 'from-emerald-500 to-teal-500', 'from-violet-500 to-purple-500', 'from-orange-500 to-amber-500', 'from-pink-500 to-rose-500', 'from-cyan-500 to-sky-500', 'from-indigo-500 to-blue-500']

const teamMembers = computed(() => [
  {
    name: '赵建良', nameEn: 'Prof. Zhao Jianliang', title: '中心主任 / Director',
    role: props.locale === 'zh' ? '中心主任' : 'Director',
    expertise: '香港中文大学（深圳）校长讲座教授',
    avatar: '/sources/jianliangzhao.jpeg', email: 'leonzhao@cuhk.edu.cn',
    links: { website: 'https://myweb.cuhk.edu.cn/leonzhao' }, color: colors[0],
    education: [
      { degree: 'PhD', field: props.locale === 'zh' ? '经济学' : 'Economics', school: 'UC Berkeley' },
      { degree: 'MBA', field: props.locale === 'zh' ? '工商管理' : 'Business Administration', school: 'UC Berkeley' },
      { degree: 'M.Eng', field: props.locale === 'zh' ? '工程学' : 'Engineering', school: 'UC Davis' },
    ],
  },
  {
    name: '石仁达', nameEn: 'Ren Shi', title: 'Assistant Director 助理主任 · 开发主管',
    role: props.locale === 'zh' ? '助理主任' : 'Asst. Director',
    expertise: '人工智能协作，多模态算法',
    avatar: '/sources/rendashi.jpeg', email: 'renshi@cuhk.edu.cn',
    links: { website: '/profile.html', github: 'https://github.com/reneverland/' }, color: colors[1],
    education: [
      { degree: 'MMS', field: props.locale === 'zh' ? '管理学' : 'Management', school: 'Duke University' },
      { degree: 'MS', field: props.locale === 'zh' ? '金融工程' : 'Financial Engineering', school: 'NCSU' },
      { degree: 'BS', field: props.locale === 'zh' ? '计算机科学 & 数学' : 'CS & Math', school: 'NCSU' },
    ],
  },
  {
    name: '徐睿沄', nameEn: 'Xu Ruiyun', title: '助理教授 / Assistant Professor',
    role: props.locale === 'zh' ? '助理教授' : 'Asst. Professor',
    expertise: '金融科技，人工智能，区块链，智能医疗',
    avatar: '/sources/xuruiyun.jpeg', email: 'ruiyunxu@cuhk.edu.cn', color: colors[2],
    education: [
      { degree: 'PhD', field: props.locale === 'zh' ? '信息系统' : 'Information Systems', school: 'CityU HK' },
      { degree: 'BS', field: props.locale === 'zh' ? '计算机科学' : 'Computer Science', school: 'BFSU' },
    ],
  },
  {
    name: '胡维', nameEn: 'Hu Wei', title: '助理研究员 / Assistant Researcher',
    role: props.locale === 'zh' ? '研究员' : 'Researcher',
    expertise: '金融科技，众筹，移动营销，区块链',
    avatar: '/sources/huwei.jpeg', email: 'huwei72@126.com', color: colors[3],
    education: [
      { degree: 'PhD', field: props.locale === 'zh' ? '信息系统' : 'Information Systems', school: 'CityU HK' },
      { degree: 'MSc', field: props.locale === 'zh' ? '数学金融与精算' : 'Math Finance & Actuarial', school: 'CityU HK' },
      { degree: 'BS', field: props.locale === 'zh' ? '应用物理' : 'Applied Physics', school: props.locale === 'zh' ? '同济大学' : 'Tongji University' },
    ],
  },
  {
    name: '李立涛', nameEn: 'Li Litao', title: '研究助理 / Research Assistant',
    role: props.locale === 'zh' ? '研究助理' : 'RA',
    expertise: '应用机器学习，知识图谱，自然语言处理',
    avatar: '/sources/lilitao.jpeg', email: 'litaoli@link.cuhk.edu.cn', color: colors[4],
    education: [
      { degree: props.locale === 'zh' ? 'PhD（在读）' : 'PhD (ongoing)', field: props.locale === 'zh' ? '信息管理与商业分析' : 'IM & BA', school: 'CUHK-Shenzhen' },
      { degree: 'MSc', field: props.locale === 'zh' ? '信息管理与商业分析' : 'IM & BA', school: 'CUHK-Shenzhen' },
      { degree: 'BS', field: '', school: props.locale === 'zh' ? '江西财经大学' : 'Jiangxi U. of Finance & Economics' },
    ],
  },
  {
    name: '沈宇阳', nameEn: 'Shen Yuyang', title: '开发工程师 / Development Engineer',
    role: props.locale === 'zh' ? '开发工程师' : 'Dev Engineer',
    expertise: '序列决策学习，表征学习，生成式智能体',
    avatar: '/sources/yuyan.png', email: 'yuyangshen@link.cuhk.edu.cn', color: colors[5],
    education: [
      { degree: 'MSc', field: props.locale === 'zh' ? '信息管理与商业分析' : 'IM & BA', school: 'CUHK-Shenzhen' },
      { degree: 'BS', field: '', school: props.locale === 'zh' ? '西南财经大学' : 'SWUFE' },
    ],
  },
  {
    name: '龚少一', nameEn: 'Gong Shaoyi', title: '开发工程师 / Development Engineer',
    role: props.locale === 'zh' ? '开发工程师' : 'Dev Engineer',
    expertise: '人工智能，医学AI，智能医疗',
    avatar: '/sources/shaoyi.jpg', email: '12518440@zju.edu.cn',
    links: { website: '/shaoyiprofile.html' }, color: colors[6],
    education: [
      { degree: props.locale === 'zh' ? 'PhD（在读）' : 'PhD (ongoing)', field: '', school: props.locale === 'zh' ? '浙江大学' : 'Zhejiang University' },
      { degree: 'BS', field: '', school: props.locale === 'zh' ? '中山大学' : 'Sun Yat-sen University' },
    ],
  },
  {
    name: '李沐子', nameEn: 'Li Muzi', title: '测试工程师 / Test Engineer',
    role: props.locale === 'zh' ? '测试工程师' : 'Test Engineer',
    expertise: props.locale === 'zh' ? '计算性城市设计，智慧城市，数字孪生' : 'Computational Urban Design, Smart City, Digital Twin',
    avatar: '/sources/limuzi.jpg', email: '', color: colors[7 % colors.length],
    education: [
      { degree: 'MSc', field: props.locale === 'zh' ? '城市设计' : 'Urban Design', school: props.locale === 'zh' ? '香港中文大学' : 'CUHK' },
      { degree: 'BS', field: props.locale === 'zh' ? '城乡规划' : 'Urban & Rural Planning', school: props.locale === 'zh' ? '海南大学' : 'Hainan University' },
    ],
  },
  {
    name: '刁玉钦', nameEn: 'Diao Yuqin', title: '研究助理 / Research Assistant',
    role: props.locale === 'zh' ? '研究助理' : 'RA',
    expertise: '人工智能，多智能体协同优化，运筹优化',
    avatar: '/sources/yuqin.png', email: 'diaoyuqin@cuhk.edu.cn',
    links: { website: '/yuqinprofile.html' }, color: colors[0],
  },
])

onMounted(() => {
  gsap.context(() => {
    gsap.fromTo('.team-title', { opacity: 0, y: 40 }, { opacity: 1, y: 0, duration: 0.8, ease: 'expo.out', scrollTrigger: { trigger: sectionRef.value, start: 'top 70%', toggleActions: 'play none none reverse' } })
    gsap.fromTo(gridRef.value?.querySelectorAll('.team-card') || [], { opacity: 0, y: 50, scale: 0.95 }, { opacity: 1, y: 0, scale: 1, duration: 0.6, stagger: 0.08, ease: 'expo.out', scrollTrigger: { trigger: gridRef.value, start: 'top 75%', toggleActions: 'play none none reverse' } })
  }, sectionRef)
})
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
