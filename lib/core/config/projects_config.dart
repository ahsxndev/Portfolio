import 'package:myfolio/features/portfolio/models/project_model.dart';

/// ============================================
/// 🚀 PROJECTS CONFIGURATION
/// ============================================
///
/// ⚠️ IMPORTANT: Update this file with your own projects!
///
/// 📝 Instructions:
/// 1. Replace the projects below with your own work
/// 2. Add your project images to assets/images/projects/
/// 3. Add project icons to assets/images/projects/icons/ (optional)
/// 4. Update GitHub URLs with your actual repositories
/// 5. Make sure to update pubspec.yaml with new image assets
///
/// 💡 Tip: You can add as many projects as you want!
///
/// ============================================

class ProjectsConfig {
  /// List of your projects to showcase in the portfolio
  static const List<ProjectModel> projects = [
    // ============================================
    // 📱 PROJECT 1
    // ============================================
    ProjectModel(
      id: '1',
      title: 'VoiceVerse AI',
      description:
          'A sleek, real-time voice assistant app built with Flutter, enabling users to interact via voice or text.',
      imageUrl: 'assets/images/projects/project1.png',
      iconUrl: 'assets/images/projects/icons/icon1.png',
      technologies: ['Flutter', 'Dart', 'Gemini AI'],
      githubUrl: 'https://github.com/ahsxndev/flutter-chat-ai',
    ),

    // ============================================
    // 📱 PROJECT 2
    // ============================================
    ProjectModel(
      id: '2',
      title: 'The Holy Qur\'an App',
      description:
          'Al-Quran mobile app featuring prayer times, accurate Hijri dates, and complete offline support for audio.',
      imageUrl: 'assets/images/projects/project2.png',
      iconUrl: 'assets/images/projects/icons/icon2.png',
      technologies: ['Flutter', 'Dart', 'REST API'],
      githubUrl: 'https://github.com/ahsxndev/quran-app',
    ),

    // ============================================
    // 📱 PROJECT 3
    // ============================================
    ProjectModel(
      id: '3',
      title: 'Instagram Clone',
      description:
          'Clean, modern Instagram clone featuring real-time feed, image uploads, and secure authentication.',
      imageUrl: 'assets/images/projects/project3.png',
      iconUrl: 'assets/images/projects/icons/icon3.png',
      technologies: ['Flutter', 'Firebase', 'Provider'],
      githubUrl: 'https://github.com/ahsxndev/instagram-clone',
    ),

    // ============================================
    // 📱 PROJECT 4
    // ============================================
    ProjectModel(
      id: '4',
      title: 'Notes App',
      description:
          'A clean, responsive, and beautifully animated notes app built with Flutter & SQLite for local storage.',
      imageUrl: 'assets/images/projects/project4.png',
      iconUrl: '', // Empty string to trigger fallback icon
      technologies: ['Flutter', 'Dart', 'SQLite'],
      githubUrl: 'https://github.com/ahsxndev/notes_app',
    ),

    // ============================================
    // 📱 PROJECT 5
    // ============================================
    ProjectModel(
      id: '5',
      title: 'COVID-19 Tracker',
      description:
          'A real-time COVID-19 tracking application built with Flutter for monitoring global pandemic statistics.',
      imageUrl: 'assets/images/projects/project5.png',
      iconUrl: 'assets/images/projects/icons/icon5.png',
      technologies: ['Flutter', 'Dart', 'REST API'],
      githubUrl: 'https://github.com/ahsxndev/covid19-tracker',
    ),

    // ============================================
    // 💡 ADD MORE PROJECTS HERE
    // ============================================
    //
    // Copy the ProjectModel structure above and add your own projects:
    //
    // ProjectModel(
    //   id: '6',
    //   title: 'Your Project Name',
    //   description: 'Your project description here...',
    //   imageUrl: 'assets/images/projects/your_project.png',
    //   iconUrl: 'assets/images/projects/icons/your_icon.png',
    //   technologies: ['Technology1', 'Technology2', 'Technology3'],
    //   githubUrl: 'https://github.com/yourusername/your-repo',
    // ),
  ];
}
