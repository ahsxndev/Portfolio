/// ============================================
/// 🔧 USER INFORMATION CONFIGURATION
/// ============================================
///
/// ⚠️ IMPORTANT: This is the MAIN file to customize your portfolio!
///
library;
/// 📝 Instructions:
/// 1. Replace all the information below with your own details
/// 2. Make sure to update your profile image in assets/images/my_pic.jpg
/// 3. Update your projects in projects_config.dart
/// 4. Update your social links in social_links_config.dart
/// ============================================

class UserInfoConfig {
  // ============================================
  // 👤 PERSONAL INFORMATION
  // ============================================

  /// Your full name (displayed in header, footer, and drawer)
  static const String fullName = 'Ahsan Zaman';

  /// Your first name for greeting (displayed in home section)
  static const String firstName = 'Ahsan';

  /// Your professional title/role
  static const String jobTitle = 'Flutter Developer';

  /// Your email address (displayed in contact section)
  static const String email = 'ahsanzaman.dev@gmail.com';

  /// Your phone number (for WhatsApp contact)
  static const String phone = '+923424083570';

  /// Copyright year (displayed in footer)
  static const String copyrightYear = '2025';

  // ============================================
  // 💼 PROFESSIONAL INFORMATION
  // ============================================

  /// Your professional bio/description (displayed in home section)
  static const String professionalBio = '''
I am a passionate Flutter developer with expertise in creating beautiful, 
responsive mobile applications. I love turning ideas into reality through 
clean code and intuitive user experiences.''';

  /// Your skills (displayed in about section)
  static const String skillsDescription =
      'UI/UX Designer\nFlutter Developer\nTechnical Writer';

  /// List of your main skills/badges
  static const List<String> skillsBadges = [
    'Flutter Developer',
    'C++', 'C#', 'Python',
    'Dart Programming',
    'Mobile App Development',
    'UI/UX Design',
    'Firebase Integration',
    'API Integration',
    'State Management',
    'Technical Writing',
  ];

  // ============================================
  // 🛠️ SERVICES INFORMATION
  // ============================================

  /// Services you offer (displayed in services section)
  static const List<ServiceInfo> services = [
    ServiceInfo(
      title: 'Flutter Developer',
      description:
          'Building cross-platform mobile applications with beautiful UI and smooth performance. From concept to deployment, creating apps that users love.',
      debugMessage: 'Flutter Developer card pressed',
      features: [
        'Cross-platform development with Flutter',
        'Native iOS and Android applications',
        'App Store and Google Play deployment',
        'Push notifications and real-time features',
        'Offline functionality and data synchronization',
        'Performance optimization and testing',
      ],
      technologies: [
        'Flutter',
        'Dart',
        'Firebase',
        'SQLite',
        'REST APIs',
        'Git',
      ],
    ),
    ServiceInfo(
      title: 'UI/UX Design',
      description:
          'Creating intuitive and visually appealing user interfaces with great user experience. Designing user journeys that are seamless and delightful.',
      debugMessage: 'UI/UX Design card pressed',
      features: [
        'User research and persona development',
        'Wireframing and prototyping',
        'Visual design and branding',
        'Usability testing and optimization',
        'Design systems and style guides',
        'Accessibility compliance',
      ],
      technologies: [
        'Figma',
        'Adobe XD',
        'Sketch',
        'Canva',
        'Photoshop',
        'Illustrator',
        'Principle',
      ],
    ),
    ServiceInfo(
      title: 'Technical Writing',
      description:
          'Creating clear and concise documentation, tutorials, and blog content. Translating complex technical concepts into engaging and easy-to-follow writing.',
      debugMessage: 'Technical Writing card pressed',
      features: [
        'API documentation and guides',
        'User manuals and tutorials',
        'Technical blog posts and articles',
        'Code documentation and comments',
        'Project specifications and requirements',
        'Training materials and presentations',
      ],
      technologies: [
        'Markdown',
        'GitBook',
        'Confluence',
        'Notion',
        'Swagger',
        'Postman',
      ],
    ),
    ServiceInfo(
      title: 'API Integration',
      description:
          'Seamlessly connecting mobile apps with backend services and third-party APIs. Ensuring secure and efficient data flow in your applications.',
      debugMessage: 'API Integration card pressed',
      features: [
        'RESTful API development and integration',
        'Database design and optimization',
        'Authentication and security implementation',
        'Cloud deployment and scaling',
        'Real-time data processing',
        'Integration with third-party services',
      ],
      technologies: ['Node.js', 'Python', 'PostgreSQL', 'Docker', 'AWS'],
    ),
    ServiceInfo(
      title: 'App Optimization',
      description:
          'Improving app performance, reducing load times, and optimizing user experience. Making your apps faster, smoother, and more efficient.',
      debugMessage: 'App Optimization card pressed',
      features: [
        'Performance analysis and monitoring',
        'Code optimization and refactoring',
        'Memory management and resource optimization',
        'UI/UX performance improvements',
        'Bundle size reduction techniques',
        'Loading speed optimization',
      ],
      technologies: [
        'Flutter DevTools',
        'Firebase Performance',
        'Dart Observatory',
        'Webpack',
        'Bundle Analyzer',
      ],
    ),
  ];

  // ============================================
  // 📱 APP INFORMATION
  // ============================================

  /// Your app title (displayed in title bar)
  static const String appTitle = 'My Folio';

  /// Profile image path (make sure to place your image here)
  static const String profileImagePath = 'assets/images/my_pic.jpg';
}

/// Helper class for service information
class ServiceInfo {
  final String title;
  final String description;
  final String debugMessage;
  final List<String> features;
  final List<String> technologies;

  const ServiceInfo({
    required this.title,
    required this.description,
    required this.debugMessage,
    required this.features,
    required this.technologies,
  });
}
