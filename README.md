# 🚀 MyFolio - Flutter Portfolio App

A modern, responsive, and highly customizable Flutter portfolio application designed to showcase your skills, projects, and professional journey. Built with clean architecture principles and a focus on user experience.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

## ✨ Features

### 🎨 **Modern Design**
- Clean and professional UI design
- Responsive layout for all screen sizes
- Smooth animations and transitions
- Custom color scheme and typography

### 📱 **Cross-Platform**
- iOS, Android, Web, Windows, macOS, and Linux support
- Progressive Web App (PWA) capabilities
- Responsive design that works on all devices

### 🛠️ **Core Sections**
- **Home**: Eye-catching introduction with animated text
- **About**: Professional bio and skills showcase
- **Services**: Detailed service offerings with modal dialogs
- **Projects**: Portfolio showcase with GitHub integration
- **Contact**: Multi-channel contact form with email integration

### 🎯 **Professional Features**
- **APK Download**: Direct download link for Android app
- **Social Media Integration**: LinkedIn, GitHub, Twitter, and more
- **Email Contact**: Real email functionality via EmailJS
- **WhatsApp Integration**: Direct messaging capability
- **Responsive Navigation**: Drawer for mobile, tabs for desktop

### 💼 **Business Ready**
- SEO optimized for web deployment
- Professional footer with legal links
- Contact form with validation
- Service detail modals
- Project showcase with technology tags

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a **Feature-Based** folder structure:

```
lib/
├── core/                          # Core functionality
│   ├── config/                    # Configuration files
│   │   ├── user_info_config.dart # 👤 Your personal information
│   │   ├── projects_config.dart  # 🚀 Your projects data
│   │   └── social_links_config.dart # 🔗 Social media links
│   └── constants/                 # App constants
│       ├── app_colors.dart       # 🎨 Color scheme
│       ├── app_text_styles.dart  # 📝 Typography
│       └── responsive.dart       # 📱 Responsive utilities
├── features/                      # Feature modules
│   └── portfolio/                # Portfolio feature
│       ├── models/               # Data models
│       ├── data/                 # Data layer
│       └── presentation/         # UI layer
│           ├── screens/          # Screen widgets
│           ├── sections/         # Section widgets
│           └── widgets/          # Reusable widgets
└── main.dart                     # App entry point
```

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.8.1 or later)
- Dart SDK (3.3.0 or later)
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ahsxndev/myfolio.git
   cd myfolio
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

4. **Build for production**
   ```bash
   # For Web
   flutter build web
   
   # For Android
   flutter build apk --release
   
   # For iOS
   flutter build ios --release
   ```

## ⚙️ Customization

### 1. 👤 Personal Information

Edit `lib/core/config/user_info_config.dart`:

```dart
class UserInfoConfig {
  static const String fullName = 'Your Name';
  static const String firstName = 'Your';
  static const String jobTitle = 'Your Job Title';
  static const String email = 'your.email@example.com';
  static const String phone = '+1234567890';
  // ... more configurations
}
```

### 2. 🚀 Projects

Update `lib/core/config/projects_config.dart`:

```dart
static const List<ProjectModel> projects = [
  ProjectModel(
    id: '1',
    title: 'Your Project',
    description: 'Project description...',
    imageUrl: 'assets/images/projects/your_project.png',
    technologies: ['Flutter', 'Dart', 'Firebase'],
    githubUrl: 'https://github.com/yourusername/project',
  ),
  // Add more projects...
];
```

### 3. 🔗 Social Links

Configure `lib/core/config/social_links_config.dart`:

```dart
class SocialLinksConfig {
  static const String linkedinUrl = 'https://linkedin.com/in/yourprofile';
  static const String githubUrl = 'https://github.com/yourusername';
  static const String twitterUrl = 'https://twitter.com/yourhandle';
  // ... more social links
}
```

### 4. 🖼️ Assets

Replace the following files with your own:

- `assets/images/my_pic.jpg` - Your profile picture
- `assets/images/projects/` - Your project screenshots
- Update `pubspec.yaml` if adding new assets

## 📦 Dependencies

### Core Dependencies
- `flutter` - Flutter SDK
- `cupertino_icons` - iOS style icons
- `google_fonts` - Custom typography
- `animated_text_kit` - Text animations
- `font_awesome_flutter` - FontAwesome icons
- `url_launcher` - External URL handling

### Dev Dependencies
- `flutter_test` - Testing framework
- `flutter_lints` - Code analysis

## 🌐 Deployment

### Web Deployment

1. **Build for web**
   ```bash
   flutter build web --release
   ```

2. **Deploy to GitHub Pages**
   - Copy `build/web/` contents to your GitHub Pages repository
   - Or use GitHub Actions for automatic deployment

3. **Deploy to Firebase Hosting**
   ```bash
   firebase init hosting
   firebase deploy
   ```

### Mobile App Stores

1. **Android (Google Play Store)**
   ```bash
   flutter build appbundle --release
   ```

2. **iOS (App Store)**
   ```bash
   flutter build ios --release
   ```

## 📱 Responsive Design

The app is fully responsive and adapts to different screen sizes:

- **Mobile** (< 768px): Single column layout with drawer navigation
- **Tablet** (768px - 1024px): Optimized spacing and components
- **Desktop** (> 1024px): Multi-column layout with enhanced interactions

## 🎨 Theming

### Color Scheme
The app uses a professional color palette defined in `app_colors.dart`:

- Primary: Custom blue tones
- Accent: Yellow for highlights
- Neutral: Grayscale variants
- Semantic: Success, warning, error colors

### Typography
Custom text styles using Montserrat font family for a modern, professional look.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Font Awesome for the beautiful icons
- Google Fonts for typography
- All open-source contributors

## 📞 Contact

**Ahsan Zaman** - Flutter Developer

- 📧 Email: ahsanzaman.dev@gmail.com
- 💼 LinkedIn: [Your LinkedIn Profile](https://linkedin.com/in/yourprofile)
- 🐙 GitHub: [ahsxndev](https://github.com/ahsxndev)
- 📱 Phone: +923424083570

---

### 🌟 **If you found this project helpful, please give it a star!** ⭐

Made with 💙 using Flutter
