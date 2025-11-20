<template>
  <div class="min-h-screen bg-white dark:bg-gray-900 transition-colors duration-300">
    <!-- Navigation/Back Button -->
    <nav class="absolute top-0 left-0 p-6 z-50">
      <a href="/" class="flex items-center gap-2 text-gray-600 dark:text-gray-300 hover:text-blue-500 dark:hover:text-blue-400 transition-colors group">
        <i class="ri-arrow-left-line text-xl group-hover:-translate-x-1 transition-transform"></i>
        <span class="font-medium">Back to Home</span>
      </a>
    </nav>

    <!-- Hero Section -->
    <div class="container mx-auto px-6 py-24 md:py-32">
      <div class="flex flex-col md:flex-row items-center md:items-start gap-12">
        <!-- Profile Image -->
        <div class="w-48 h-48 md:w-64 md:h-64 flex-shrink-0 relative">
          <div class="absolute inset-0 bg-gradient-to-br from-blue-500 to-purple-600 rounded-2xl rotate-6 opacity-20"></div>
          <img 
            src="/sources/shaoyi.jpg" 
            alt="Gong Shaoyi" 
            class="w-full h-full object-cover rounded-2xl shadow-xl relative z-10"
          >
        </div>

        <!-- Main Info -->
        <div class="flex-1 text-center md:text-left">
          <h1 class="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-4 tracking-tight">
            龚少一 <span class="text-2xl text-gray-500 font-normal ml-2">Shaoyi</span>
          </h1>
          <div class="flex flex-wrap justify-center md:justify-start gap-4 mb-8">
            <div class="flex items-center gap-2 text-gray-600 dark:text-gray-300">
              <i class="ri-mail-send-line text-blue-500"></i>
              <a href="mailto:12518440@zju.edu.cn" class="hover:text-blue-500 transition-colors">
                12518440@zju.edu.cn
              </a>
            </div>
            <div class="flex items-center gap-2 text-gray-600 dark:text-gray-300">
              <i class="ri-map-pin-user-line text-blue-500"></i>
              <span>Shenzhen, China</span>
            </div>
          </div>
          
          <!-- Research Areas -->
          <div class="mb-8">
            <h3 class="text-sm font-semibold text-gray-400 uppercase tracking-wider mb-3">Research Areas / 研究领域</h3>
            <div class="flex flex-wrap gap-2 justify-center md:justify-start">
              <span class="px-4 py-2 bg-blue-50 dark:bg-blue-900/30 text-blue-700 dark:text-blue-300 rounded-full text-sm font-medium">
                Artificial Intelligence
              </span>
              <span class="px-4 py-2 bg-purple-50 dark:bg-purple-900/30 text-purple-700 dark:text-purple-300 rounded-full text-sm font-medium">
                Medical AI
              </span>
              <span class="px-4 py-2 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-300 rounded-full text-sm font-medium">
                Healthcare Technology
              </span>
            </div>
          </div>
        </div>
      </div>

      <!-- Content Grid -->
      <div class="grid md:grid-cols-2 gap-12 mt-16">
        <!-- Left Column: Education -->
        <div class="space-y-8">
          <section>
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-3">
              <i class="ri-graduation-cap-line text-blue-500"></i>
              Education / 教育背景
            </h2>
            <div class="relative pl-8 border-l-2 border-gray-100 dark:border-gray-700 space-y-8">
              <!-- PhD -->
              <div class="relative">
                <div class="absolute -left-[39px] w-5 h-5 bg-white dark:bg-gray-900 border-4 border-blue-500 rounded-full"></div>
                <div class="bg-gray-50 dark:bg-gray-800/50 p-6 rounded-xl">
                  <h3 class="text-lg font-bold text-gray-900 dark:text-white">Ph.D. Candidate</h3>
                  <p class="text-gray-600 dark:text-gray-300 mt-1">Zhejiang University</p>
                  <p class="text-sm text-gray-500 mt-2">浙江大学 | 博士研究生</p>
                </div>
              </div>

              <!-- Bachelor -->
              <div class="relative">
                <div class="absolute -left-[39px] w-5 h-5 bg-white dark:bg-gray-900 border-4 border-purple-500 rounded-full"></div>
                <div class="bg-gray-50 dark:bg-gray-800/50 p-6 rounded-xl">
                  <h3 class="text-lg font-bold text-gray-900 dark:text-white">Bachelor's Degree</h3>
                  <p class="text-gray-600 dark:text-gray-300 mt-1">Sun Yat-sen University</p>
                  <p class="text-sm text-gray-500 mt-2">中山大学 | 学士学位</p>
                </div>
              </div>
            </div>
          </section>

          <section>
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-3">
              <i class="ri-briefcase-line text-blue-500"></i>
              Experience / 工作经历
            </h2>
            <div class="relative pl-8 border-l-2 border-gray-100 dark:border-gray-700 space-y-8">
              <!-- RA -->
              <div class="relative">
                <div class="absolute -left-[39px] w-5 h-5 bg-white dark:bg-gray-900 border-4 border-blue-500 rounded-full"></div>
                <div class="bg-gray-50 dark:bg-gray-800/50 p-6 rounded-xl">
                  <h3 class="text-lg font-bold text-gray-900 dark:text-white">Research Assistant</h3>
                  <p class="text-gray-600 dark:text-gray-300 mt-1">CUHK-Shenzhen Blockchain and Intelligent Technology Research Center</p>
                  <p class="text-sm text-gray-500 mt-2">香港中文大学(深圳) | 区块链与智能科技研究中心研究助理</p>
                </div>
              </div>
            </div>
          </section>
        </div>

        <!-- Right Column: Research Interests -->
        <div class="space-y-8">
          <section>
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-3">
              <i class="ri-lightbulb-line text-purple-500"></i>
              Research Interests / 研究兴趣
            </h2>
            <div class="space-y-4">
              <div class="group p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 hover:shadow-lg hover:border-blue-200 dark:hover:border-blue-900 transition-all duration-300">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                  Artificial Intelligence in Healthcare
                </h3>
                <p class="text-gray-600 dark:text-gray-300 text-sm">
                  Application of AI technologies in medical diagnosis, treatment planning, and healthcare optimization.
                </p>
                <p class="text-gray-500 dark:text-gray-400 text-sm mt-2">
                  人工智能在医疗健康领域的应用，包括医疗诊断、治疗方案规划和医疗优化。
                </p>
              </div>

              <div class="group p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 hover:shadow-lg hover:border-blue-200 dark:hover:border-blue-900 transition-all duration-300">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                  Medical Data Analysis
                </h3>
                <p class="text-gray-600 dark:text-gray-300 text-sm">
                  Advanced analytics and machine learning methods for processing and interpreting medical data.
                </p>
                <p class="text-gray-500 dark:text-gray-400 text-sm mt-2">
                  医疗数据分析和机器学习方法在处理和解释医疗数据中的应用。
                </p>
              </div>

              <div class="group p-6 bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 hover:shadow-lg hover:border-blue-200 dark:hover:border-blue-900 transition-all duration-300">
                <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                  Intelligent Medical Systems
                </h3>
                <p class="text-gray-600 dark:text-gray-300 text-sm">
                  Development of smart healthcare systems integrating AI, IoT, and blockchain technologies.
                </p>
                <p class="text-gray-500 dark:text-gray-400 text-sm mt-2">
                  智能医疗系统开发，结合人工智能、物联网和区块链技术。
                </p>
              </div>
            </div>
          </section>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <footer class="border-t border-gray-100 dark:border-gray-800 mt-20 bg-gray-50 dark:bg-gray-800/30">
      <div class="container mx-auto px-6 py-12 text-center">
        <p class="text-gray-500 dark:text-gray-400">
          © {{ new Date().getFullYear() }} Gong Shaoyi. All rights reserved.
        </p>
        <p class="text-gray-400 dark:text-gray-500 text-sm mt-2">
          <a href="https://cbit.cuhk.edu.cn" target="_blank" class="hover:text-blue-500 transition-colors">CBIT Research Center</a> Member
        </p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'

// Dark mode handling
onMounted(() => {
  // Check system preference or saved preference
  if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
    document.documentElement.classList.add('dark')
  }
})
</script>

