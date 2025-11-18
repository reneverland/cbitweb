<template>
  <div class="center-projects bg-white dark:bg-gray-800 rounded-2xl p-6 shadow-lg border border-gray-200 dark:border-gray-700">
    <div class="flex items-center justify-between mb-6">
      <div class="flex-1">
        <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-2">
          {{ locale === 'zh' ? '中心项目' : 'Center Projects' }}
        </h3>
        <p class="text-sm text-gray-600 dark:text-gray-300">
          {{ locale === 'zh' ? '我们的核心研究与应用项目' : 'Our Core Research and Application Projects' }}
        </p>
      </div>
      <button 
        @click="isExpanded = !isExpanded"
        class="ml-4 flex-shrink-0 w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 transition-all duration-300 group"
        :title="isExpanded ? (locale === 'zh' ? '收起' : 'Collapse') : (locale === 'zh' ? '展开全部' : 'Show All')"
      >
        <i :class="isExpanded ? 'ri-arrow-up-s-line' : 'ri-arrow-down-s-line'" class="text-xl text-gray-600 dark:text-gray-300 group-hover:text-primary transition-colors"></i>
      </button>
    </div>

    <!-- 预览模式：显示最新2个项目 -->
    <div v-if="!isExpanded" class="space-y-4">
      <div class="space-y-4">
        <!-- 项目1: 香港中文大学（深圳）智能咨询系统 -->
        <div class="project-card bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-gray-700 dark:to-gray-600 rounded-xl p-4 hover:shadow-lg transition-all duration-300">
            <div class="flex items-start justify-between mb-2">
              <h5 class="font-semibold text-gray-900 dark:text-white flex-1">
                {{ locale === 'zh' ? '香港中文大学（深圳）智能咨询系统（SME）' : 'CUHK-Shenzhen Intelligent Consulting System (SME)' }}
              </h5>
              <span class="text-xs text-gray-500 dark:text-gray-400 whitespace-nowrap ml-2">2023 – 2025</span>
            </div>
            
            <p class="text-sm text-gray-700 dark:text-gray-300 mb-3">
              <strong>{{ locale === 'zh' ? '项目目标：' : 'Goal:' }}</strong>
              {{ locale === 'zh' ? '为研究生招生、教务、政策咨询提供智能化回答系统，实现信息发布自动化、FAQ 智能匹配与流程指引。' : 'Provide intelligent Q&A system for graduate admissions, academic affairs, and policy consultation.' }}
            </p>
            
            <div class="mb-3">
              <p class="text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">
                {{ locale === 'zh' ? '核心功能与成果：' : 'Core Features:' }}
              </p>
              <ul class="text-xs text-gray-600 dark:text-gray-400 space-y-1 ml-4">
                <li>• {{ locale === 'zh' ? 'Q&A 智能助手（支持复杂政策问答、学费、奖学金、课程）' : 'Q&A AI Assistant (policy, tuition, scholarships, courses)' }}</li>
                <li>• {{ locale === 'zh' ? '学院知识库构建（PDF/网页内容自动抽取）' : 'Knowledge base construction (PDF/webpage auto extraction)' }}</li>
                <li>• {{ locale === 'zh' ? 'LLM + RAG 答复体系（知识专属、可信回答）' : 'LLM + RAG system (knowledge-specific, reliable answers)' }}</li>
              </ul>
            </div>
            
            <div class="text-xs text-gray-500 dark:text-gray-400">
              <strong>{{ locale === 'zh' ? '核心技术：' : 'Tech Stack:' }}</strong>
              Qwen, LLM Fine-tuning, Qdrant, RAG, Policy Parsing
            </div>
          </div>

        <!-- 项目2: 广东以色列理工学院招生AI系统 -->
        <div class="project-card bg-gradient-to-r from-green-50 to-emerald-50 dark:from-gray-700 dark:to-gray-600 rounded-xl p-4 hover:shadow-lg transition-all duration-300">
            <div class="flex items-start justify-between mb-2">
              <h5 class="font-semibold text-gray-900 dark:text-white flex-1">
                {{ locale === 'zh' ? '广东以色列理工学院（GTIIT）招生 AI 系统' : 'GTIIT Admissions AI System' }}
              </h5>
              <span class="text-xs text-gray-500 dark:text-gray-400 whitespace-nowrap ml-2">2025 – {{ locale === 'zh' ? '持续' : 'Ongoing' }}</span>
            </div>
            
            <p class="text-sm text-gray-700 dark:text-gray-300 mb-3">
              <strong>{{ locale === 'zh' ? '项目目标：' : 'Goal:' }}</strong>
              {{ locale === 'zh' ? '人工智能驱动的招生问答、政策解释与招生策略推荐系统。' : 'AI-driven admissions Q&A, policy interpretation, and strategy recommendation system.' }}
            </p>
            
            <div class="mb-3">
              <p class="text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">
                {{ locale === 'zh' ? '功能模块：' : 'Features:' }}
              </p>
              <ul class="text-xs text-gray-600 dark:text-gray-400 space-y-1 ml-4">
                <li>• {{ locale === 'zh' ? '招生政策问答' : 'Admissions Policy Q&A' }}</li>
                <li>• {{ locale === 'zh' ? '招生流程指引' : 'Admissions Process Guidance' }}</li>
                <li>• {{ locale === 'zh' ? '国际办学体系常见问题解析' : 'International Education System FAQ' }}</li>
                <li>• {{ locale === 'zh' ? '招生材料自动校验（初步版）' : 'Auto Verification of Admission Materials' }}</li>
              </ul>
            </div>
            
            <div class="text-xs text-gray-500 dark:text-gray-400">
              <strong>{{ locale === 'zh' ? '核心技术：' : 'Tech Stack:' }}</strong>
              LLM Q&A, Multi-KB Routing, Vector Retrieval, Structured Data Parsing
            </div>
        </div>
      </div>
    </div>

    <!-- 展开模式：显示所有项目 -->
    <div v-else class="space-y-8 animate-fade-in">
      <!-- 一、教育行业与高校场景 -->
      <div class="category-section">
        <h4 class="text-base font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
          <span class="text-primary">一、</span>
          {{ locale === 'zh' ? '教育行业与高校场景' : 'Education Industry & University Scenarios' }}
        </h4>
        
        <div class="space-y-4">
          <!-- 项目1: 香港中文大学（深圳）智能咨询系统 -->
          <div class="project-card bg-gradient-to-r from-blue-50 to-indigo-50 dark:from-gray-700 dark:to-gray-600 rounded-xl p-4">
            <div class="flex items-start justify-between mb-2">
              <h5 class="font-semibold text-gray-900 dark:text-white flex-1">
                {{ locale === 'zh' ? '香港中文大学（深圳）智能咨询系统（SME）' : 'CUHK-Shenzhen Intelligent Consulting System (SME)' }}
              </h5>
              <span class="text-xs text-gray-500 dark:text-gray-400 whitespace-nowrap ml-2">2023 – 2025</span>
            </div>
            
            <p class="text-sm text-gray-700 dark:text-gray-300 mb-3">
              <strong>{{ locale === 'zh' ? '项目目标：' : 'Goal:' }}</strong>
              {{ locale === 'zh' ? '为研究生招生、教务、政策咨询提供智能化回答系统，实现信息发布自动化、FAQ 智能匹配与流程指引。' : 'Provide intelligent Q&A system for graduate admissions, academic affairs, and policy consultation.' }}
            </p>
            
            <div class="mb-3">
              <p class="text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">
                {{ locale === 'zh' ? '核心功能与成果：' : 'Core Features:' }}
              </p>
              <ul class="text-xs text-gray-600 dark:text-gray-400 space-y-1 ml-4">
                <li>• {{ locale === 'zh' ? 'Q&A 智能助手（支持复杂政策问答、学费、奖学金、课程）' : 'Q&A AI Assistant (policy, tuition, scholarships, courses)' }}</li>
                <li>• {{ locale === 'zh' ? '学院知识库构建（PDF/网页内容自动抽取）' : 'Knowledge base construction (PDF/webpage auto extraction)' }}</li>
                <li>• {{ locale === 'zh' ? 'LLM + RAG 答复体系（知识专属、可信回答）' : 'LLM + RAG system (knowledge-specific, reliable answers)' }}</li>
              </ul>
            </div>
            
            <div class="text-xs text-gray-500 dark:text-gray-400">
              <strong>{{ locale === 'zh' ? '核心技术：' : 'Tech Stack:' }}</strong>
              Qwen, LLM Fine-tuning, Qdrant, RAG, Policy Parsing
            </div>
          </div>

          <!-- 项目2: 广东以色列理工学院招生AI系统 -->
          <div class="project-card bg-gradient-to-r from-green-50 to-emerald-50 dark:from-gray-700 dark:to-gray-600 rounded-xl p-4">
            <div class="flex items-start justify-between mb-2">
              <h5 class="font-semibold text-gray-900 dark:text-white flex-1">
                {{ locale === 'zh' ? '广东以色列理工学院（GTIIT）招生 AI 系统' : 'GTIIT Admissions AI System' }}
              </h5>
              <span class="text-xs text-gray-500 dark:text-gray-400 whitespace-nowrap ml-2">2025 – {{ locale === 'zh' ? '持续' : 'Ongoing' }}</span>
            </div>
            
            <p class="text-sm text-gray-700 dark:text-gray-300 mb-3">
              <strong>{{ locale === 'zh' ? '项目目标：' : 'Goal:' }}</strong>
              {{ locale === 'zh' ? '人工智能驱动的招生问答、政策解释与招生策略推荐系统。' : 'AI-driven admissions Q&A, policy interpretation, and strategy recommendation system.' }}
            </p>
            
            <div class="mb-3">
              <p class="text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">
                {{ locale === 'zh' ? '功能模块：' : 'Features:' }}
              </p>
              <ul class="text-xs text-gray-600 dark:text-gray-400 space-y-1 ml-4">
                <li>• {{ locale === 'zh' ? '招生政策问答' : 'Admissions Policy Q&A' }}</li>
                <li>• {{ locale === 'zh' ? '招生流程指引' : 'Admissions Process Guidance' }}</li>
                <li>• {{ locale === 'zh' ? '国际办学体系常见问题解析' : 'International Education System FAQ' }}</li>
                <li>• {{ locale === 'zh' ? '招生材料自动校验（初步版）' : 'Auto Verification of Admission Materials' }}</li>
              </ul>
            </div>
            
            <div class="text-xs text-gray-500 dark:text-gray-400">
              <strong>{{ locale === 'zh' ? '核心技术：' : 'Tech Stack:' }}</strong>
              LLM Q&A, Multi-KB Routing, Vector Retrieval, Structured Data Parsing
            </div>
          </div>
        </div>
      </div>

      <!-- 二、政府场景 -->
      <div class="category-section">
        <h4 class="text-base font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
          <span class="text-secondary">二、</span>
          {{ locale === 'zh' ? '政府场景：政务 AI 与智能档案' : 'Government: E-Government AI & Smart Archives' }}
        </h4>
        
        <div class="project-card bg-gradient-to-r from-purple-50 to-pink-50 dark:from-gray-700 dark:to-gray-600 rounded-xl p-4">
          <div class="flex items-start justify-between mb-2">
            <h5 class="font-semibold text-gray-900 dark:text-white flex-1">
              {{ locale === 'zh' ? '深圳市中电一所智能制造业电子档案项目' : 'Shenzhen CEPREI Smart Manufacturing E-Archive Project' }}
            </h5>
            <span class="text-xs text-gray-500 dark:text-gray-400 whitespace-nowrap ml-2">2024 – 2025</span>
          </div>
          
          <p class="text-sm text-gray-700 dark:text-gray-300 mb-3">
            <strong>{{ locale === 'zh' ? '项目目标：' : 'Goal:' }}</strong>
            {{ locale === 'zh' ? '为大型制造业单位构建电子档案规范化系统，实现档案数字化 → 规范提取 → 结构化入库 → 可视化检索。' : 'Build standardized e-archive system for large manufacturing units with digitization, structured storage, and visual retrieval.' }}
          </p>
          
          <div class="mb-3">
            <p class="text-xs font-medium text-gray-700 dark:text-gray-300 mb-1">
              {{ locale === 'zh' ? '主要成果：' : 'Achievements:' }}
            </p>
            <ul class="text-xs text-gray-600 dark:text-gray-400 space-y-1 ml-4">
              <li>• {{ locale === 'zh' ? '完成电子档案扫描文本提取' : 'E-archive scanning and text extraction' }}</li>
              <li>• {{ locale === 'zh' ? '研制 OCR + 内容解析一体化模块' : 'Integrated OCR + content parsing module' }}</li>
              <li>• {{ locale === 'zh' ? '提供合规性校验与流程标准化' : 'Compliance verification and process standardization' }}</li>
              <li>• {{ locale === 'zh' ? '大幅提升档案检索效率（秒级搜索）' : 'Significantly improved search efficiency (sub-second)' }}</li>
            </ul>
          </div>
          
          <div class="text-xs text-gray-500 dark:text-gray-400">
            <strong>{{ locale === 'zh' ? '核心技术：' : 'Tech Stack:' }}</strong>
            OCR + NLP, LLM Parsing, Vector Retrieval, Knowledge Graph, Visualization
          </div>
        </div>
      </div>

      <!-- 三、媒体与内容 -->
      <div class="category-section">
        <h4 class="text-base font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
          <span class="text-primary">三、</span>
          {{ locale === 'zh' ? '媒体与内容：信息处理与多模态生成' : 'Media & Content: Information Processing & Multimodal Generation' }}
        </h4>
        
        <div class="project-card bg-gradient-to-r from-orange-50 to-red-50 dark:from-gray-700 dark:to-gray-600 rounded-xl p-4">
          <div class="flex items-start justify-between mb-2">
            <h5 class="font-semibold text-gray-900 dark:text-white flex-1">
              VoxChina {{ locale === 'zh' ? '内容智能化平台' : 'Intelligent Content Platform' }}
            </h5>
            <span class="text-xs text-gray-500 dark:text-gray-400 whitespace-nowrap ml-2">2025 – 2026</span>
          </div>
          
          <p class="text-sm text-gray-700 dark:text-gray-300 mb-3">
            <strong>{{ locale === 'zh' ? '目标：' : 'Goal:' }}</strong>
            {{ locale === 'zh' ? '搭建文章摘要、多篇聚合摘要、语音播报和知识问答的 AI 内容平台。' : 'Build AI content platform for article summarization, multi-article aggregation, voice broadcast, and knowledge Q&A.' }}
          </p>
          
          <div class="text-xs text-gray-500 dark:text-gray-400">
            <strong>{{ locale === 'zh' ? '核心技术：' : 'Tech Stack:' }}</strong>
            Qwen, Whisper, Text Summarization, Qdrant, RAG, Multimodal Synthesis
          </div>
        </div>
      </div>

      <!-- 四、政府采购 -->
      <div class="category-section">
        <h4 class="text-base font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
          <span class="text-secondary">四、</span>
          {{ locale === 'zh' ? '政府采购：招标文件智能核验' : 'Government Procurement: Smart Bid Document Verification' }}
        </h4>
        
        <div class="project-card bg-gradient-to-r from-teal-50 to-cyan-50 dark:from-gray-700 dark:to-gray-600 rounded-xl p-4">
          <div class="flex items-start justify-between mb-2">
            <h5 class="font-semibold text-gray-900 dark:text-white flex-1">
              {{ locale === 'zh' ? '江招招标文件智能核验平台' : 'Jiangzhao Smart Bid Verification Platform' }}
            </h5>
            <span class="text-xs text-gray-500 dark:text-gray-400 whitespace-nowrap ml-2">2025 – 2026</span>
          </div>
          
          <p class="text-sm text-gray-700 dark:text-gray-300 mb-3">
            <strong>{{ locale === 'zh' ? '目标：' : 'Goal:' }}</strong>
            {{ locale === 'zh' ? '实现招标文件的自动解析、条款核验、风险提示与合规轨迹可视化。' : 'Automated bid document parsing, clause verification, risk alerts, and compliance visualization.' }}
          </p>
          
          <div class="text-xs text-gray-500 dark:text-gray-400">
            <strong>{{ locale === 'zh' ? '核心技术：' : 'Tech Stack:' }}</strong>
            Qwen3, CBIT-Elite Fine-tuned Model, Qdrant, Improved DBSCAN, Document Parsing, Trace Analysis
          </div>
        </div>
      </div>

      <!-- 五、多模态生成 -->
      <div class="category-section">
        <h4 class="text-base font-semibold text-gray-900 dark:text-white mb-4 flex items-center gap-2">
          <span class="text-primary">五、</span>
          {{ locale === 'zh' ? '多模态生成：政务图像智能化' : 'Multimodal Generation: Government Image Intelligence' }}
        </h4>
        
        <div class="project-card bg-gradient-to-r from-yellow-50 to-amber-50 dark:from-gray-700 dark:to-gray-600 rounded-xl p-4">
          <div class="flex items-start justify-between mb-2">
            <h5 class="font-semibold text-gray-900 dark:text-white flex-1">
              {{ locale === 'zh' ? '百度深圳图像模态生成项目' : 'Baidu Shenzhen Image Generation Project' }}
            </h5>
            <span class="text-xs text-gray-500 dark:text-gray-400 whitespace-nowrap ml-2">2025 – 2026</span>
          </div>
          
          <p class="text-sm text-gray-700 dark:text-gray-300 mb-3">
            <strong>{{ locale === 'zh' ? '目标：' : 'Goal:' }}</strong>
            {{ locale === 'zh' ? '构建城市场景图像智能生成系统，实现文生图、语义一致性检验与可控生成。' : 'Build urban scene image generation system with text-to-image, semantic verification, and controllable generation.' }}
          </p>
          
          <div class="text-xs text-gray-500 dark:text-gray-400">
            <strong>{{ locale === 'zh' ? '核心技术：' : 'Tech Stack:' }}</strong>
            ComfyUI, SDXL, ControlNet, Qwen3-Coder, Qdrant, Local GPU A100 Cluster
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

defineProps({
  locale: {
    type: String,
    default: 'zh'
  }
})

const isExpanded = ref(false)
</script>

<style scoped>
.category-section {
  @apply border-l-2 border-gray-200 dark:border-gray-700 pl-4;
}

.project-card {
  @apply transition-all duration-300 hover:shadow-md;
}
</style>

