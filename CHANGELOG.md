# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-11-20

### 🎉 Initial Stable Release

This is the first production-ready release of CBIT Official Website.

### ✨ Features

#### Core Functionality
- **AI Chat System** - Integrated Dify platform for intelligent Q&A
  - Main page endpoint: `/api/apps/cbit-official/chat/completions`
  - Profile page endpoint: `/api/apps/renprofile/chat/completions`
  - Auto-suggestion for related questions
  - Context-aware multi-turn conversations
  
- **Bilingual Support** - Seamless Chinese/English switching
  - UI translations for all components
  - Dual-language content display
  - Language persistence in localStorage

- **Theme Toggle** - Dark and light mode support
  - System-wide theme consistency
  - Smooth theme transitions
  - User preference persistence

- **ICSF Conference Series** - Historical conference records (2016-2024)
  - Beautiful dropdown menu with gradient design
  - Direct links to conference pages
  - Mobile-responsive layout

- **Team Showcase** - Core member display with interactive features
  - Avatar preview with lightbox
  - Bilingual member information
  - Smooth animations

- **Multi-page Support** - Two entry points
  - Main page (index.html) - Research center introduction
  - Profile page (profile.html) - Professor Ren's personal page

#### User Experience
- **Responsive Design** - Perfect on all devices
- **Smooth Animations** - Fluid transitions and effects
- **Quick Actions** - Preset question shortcuts
- **Chat History** - Conversation persistence
- **Clear Chat** - One-click conversation reset

### 🔧 Technical Improvements

#### Frontend
- **Vue 3** with Composition API
- **Vite** for fast development and building
- **Tailwind CSS** for utility-first styling
- **Axios** for HTTP requests with proper error handling

#### Backend Integration
- **Nginx Reverse Proxy** - API forwarding with CORS handling
- **Docker Containerization** - Multi-stage builds for optimized images
- **Health Checks** - Container health monitoring
- **Auto-restart** - Resilient deployment

#### CI/CD
- **GitHub Actions** - Automated testing and building
- **Docker Registry** - Image hosting on GHCR
- **Automated Deployment** - Push to registry on main branch updates

#### Security
- **HTTPS Enforcement** - SSL/TLS encryption
- **CORS Configuration** - Proper cross-origin handling
- **OPTIONS Preflight** - Correct preflight request handling
- **Mixed Content Fix** - All resources served over HTTPS

### 🐛 Bug Fixes

#### API Integration
- Fixed hardcoded API URLs in App.vue and ProfileApp.vue
- Resolved Mixed Content security errors
- Fixed 405 Not Allowed errors with proper OPTIONS handling
- Corrected 404 errors by fixing Nginx proxy_pass configuration

#### Routing
- Fixed profile.html access issues
- Corrected multi-page application configuration in Vite
- Fixed static asset copying issues

#### Deployment
- Added BT Panel (宝塔面板) support
- Fixed Nginx configuration directory detection
- Added fallback Nginx restart methods
- Improved Docker build reliability

### 📚 Documentation

#### Added
- Comprehensive README.md with GitHub badges
- System architecture diagram
- Detailed technology stack description
- Quick start guide
- Docker deployment guide
- Nginx configuration guide (NGINX_SETUP.md)
- BT Panel deployment guide (BT_PANEL_SETUP.md)
- Server deployment guide (SERVER_DEPLOYMENT.md)
- Quick fix guide (QUICK_FIX.md)
- Quick commands reference (QUICK_COMMANDS.md)

#### Improved
- Enhanced code comments
- API documentation
- Troubleshooting guides
- Development guidelines

### 🚀 Deployment

#### Supported Platforms
- Standard Linux servers (Ubuntu, CentOS, Debian)
- BT Panel (宝塔面板) managed servers
- Docker and Docker Compose
- Any platform supporting Nginx + Docker

#### Automated Scripts
- `setup-nginx.sh` - Automated Nginx configuration
- `deploy-server.sh` - One-click deployment script
- `fix-405.sh` - Quick fix for 405 errors
- `diagnose.sh` - Deployment diagnostics

### 🔄 Migration Notes

This is the initial release, so no migration is needed.

### 🙏 Acknowledgments

Thanks to all the open-source projects that made this possible:
- Vue.js team
- Vite team
- Tailwind CSS team
- Axios team
- RemixIcon team
- Dify platform

### 📝 Notes

- Recommended Node.js version: 18.x or higher
- Recommended Docker version: 20.x or higher
- Nginx version: 1.20+ for best compatibility

---

## Future Plans

### v1.1.0 (Planned)
- [ ] User authentication system
- [ ] Comment system
- [ ] Search functionality
- [ ] RSS feed
- [ ] Performance optimizations
- [ ] PWA support

### v1.2.0 (Planned)
- [ ] Blog/News section
- [ ] Publications database
- [ ] Project showcase with filtering
- [ ] Event calendar
- [ ] Newsletter subscription

---

[1.0.0]: https://github.com/reneverland/cbitweb/releases/tag/v1.0.0

