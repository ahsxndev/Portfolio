import 'package:flutter/material.dart';

/// Navigation Controller for handling section navigation
class NavigationController {
  static final NavigationController _instance = NavigationController._internal();
  
  factory NavigationController() => _instance;
  
  NavigationController._internal();

  // Global keys for each section
  final GlobalKey homeKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey servicesKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  /// Scroll to a specific section
  void scrollToSection(String sectionName) {
    GlobalKey? targetKey;
    
    switch (sectionName.toLowerCase()) {
      case 'home':
        targetKey = homeKey;
        break;
      case 'about':
        targetKey = aboutKey;
        break;
      case 'services':
        targetKey = servicesKey;
        break;
      case 'projects':
        targetKey = projectsKey;
        break;
      case 'contact':
        targetKey = contactKey;
        break;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.0, // Top of the viewport
      );
    }
  }

  /// Get all navigation items
  List<NavigationItem> getNavigationItems() {
    return [
      NavigationItem(
        title: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        onTap: () => scrollToSection('home'),
      ),
      NavigationItem(
        title: 'About',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        onTap: () => scrollToSection('about'),
      ),
      NavigationItem(
        title: 'Services',
        icon: Icons.work_outline,
        activeIcon: Icons.work,
        onTap: () => scrollToSection('services'),
      ),
      NavigationItem(
        title: 'Projects',
        icon: Icons.folder_outlined,
        activeIcon: Icons.folder,
        onTap: () => scrollToSection('projects'),
      ),
      NavigationItem(
        title: 'Contact',
        icon: Icons.contact_mail_outlined,
        activeIcon: Icons.contact_mail,
        onTap: () => scrollToSection('contact'),
      ),
    ];
  }
}

/// Navigation item data class
class NavigationItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final VoidCallback onTap;

  NavigationItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.onTap,
  });
}
