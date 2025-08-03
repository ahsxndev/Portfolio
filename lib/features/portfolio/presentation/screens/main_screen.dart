import 'package:flutter/material.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/features/portfolio/presentation/sections/contact_section.dart';
import 'package:myfolio/features/portfolio/presentation/sections/footer.dart';
import 'package:myfolio/features/portfolio/presentation/sections/services_section.dart';
import 'package:myfolio/features/portfolio/presentation/sections/projects_section.dart';
import 'package:myfolio/features/portfolio/presentation/widgets/custom_drawer.dart';
import 'package:myfolio/features/portfolio/presentation/widgets/avatar_widget.dart';
import 'package:myfolio/features/portfolio/presentation/sections/home_section.dart';
import 'package:myfolio/features/portfolio/presentation/sections/about_section.dart';
import 'package:myfolio/features/portfolio/presentation/navigation/navigation_controller.dart';

import 'package:myfolio/core/constants/app_text_styles.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late final NavigationController navigationController;
  late final ScrollController _scrollController;
  late final AnimationController _scrollToTopController;
  late final Animation<double> _scrollToTopAnimation;
  int _activeIndex = 0; // Track active nav item
  bool _showScrollToTop = false; // Track scroll to top button visibility

  @override
  void initState() {
    super.initState();
    navigationController = NavigationController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Initialize scroll to top animation
    _scrollToTopController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scrollToTopAnimation = CurvedAnimation(
      parent: _scrollToTopController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollToTopController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollPosition = _scrollController.position.pixels;
    final screenHeight = MediaQuery.of(context).size.height;

    // Show scroll to top button when user scrolls down more than screen height
    final shouldShow = scrollPosition > screenHeight * 0.5;
    if (shouldShow != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShow;
      });
      if (shouldShow) {
        _scrollToTopController.forward();
      } else {
        _scrollToTopController.reverse();
      }
    }

    // Get section positions
    final aboutPosition = _getSectionPosition(navigationController.aboutKey);
    final servicesPosition = _getSectionPosition(
      navigationController.servicesKey,
    );
    final projectsPosition = _getSectionPosition(
      navigationController.projectsKey,
    );
    final contactPosition = _getSectionPosition(
      navigationController.contactKey,
    );

    int newActiveIndex = 0;

    // Determine which section is currently visible
    if (scrollPosition >= contactPosition - 200) {
      newActiveIndex = 4; // Contact
    } else if (scrollPosition >= projectsPosition - 200) {
      newActiveIndex = 3; // Projects
    } else if (scrollPosition >= servicesPosition - 200) {
      newActiveIndex = 2; // Services
    } else if (scrollPosition >= aboutPosition - 200) {
      newActiveIndex = 1; // About
    } else {
      newActiveIndex = 0; // Home
    }

    if (newActiveIndex != _activeIndex) {
      setState(() {
        _activeIndex = newActiveIndex;
      });
    }
  }

  double _getSectionPosition(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
          key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      return position.dy + _scrollController.position.pixels;
    }
    return 0.0;
  }

  void _onNavTap(int index, NavigationItem item) {
    setState(() {
      _activeIndex = index;
    });
    item.onTap();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isTablet = Responsive.isTablet(context);
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isSmallScreen = MediaQuery.of(context).size.width < 500;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.kYellow,
        endDrawer: (isMobile || isTablet)
            ? CustomDrawer(activeIndex: _activeIndex)
            : null,
        appBar: _buildAppBar(context, isMobile, isTablet, isDesktop),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    key: navigationController.homeKey,
                    child: const HomeSection(),
                  ),
                  SizedBox(height: isMobile ? 50 : 70),
                  Container(
                    key: navigationController.aboutKey,
                    child: const AboutSection(),
                  ),
                  SizedBox(height: isMobile ? 60 : 70),
                  Container(
                    key: navigationController.servicesKey,
                    child: const ServicesSection(),
                  ),
                  SizedBox(height: isMobile ? 60 : 70),
                  Container(
                    key: navigationController.projectsKey,
                    child: const ProjectsSection(),
                  ),
                  SizedBox(height: isMobile ? 60 : 70),
                  Container(
                    key: navigationController.contactKey,
                    child: ContactSection(),
                  ),
                  SizedBox(height: isMobile ? 60 : 70),
                  Footer(),
                  SizedBox(height: isMobile ? 30 : 40),
                ],
              ),
            ),
            // Scroll to Top Button - Only show on small screens
            if (isSmallScreen)
              Positioned(
                right: 16,
                bottom: 20,
                child: AnimatedBuilder(
                  animation: _scrollToTopAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scrollToTopAnimation.value,
                      child: Opacity(
                        opacity: _scrollToTopAnimation.value,
                        child: _ScrollToTopButton(
                          onTap: _scrollToTop,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    if (isDesktop) {
      // Desktop: Avatar left, nav items right
      final navigationItems = navigationController.getNavigationItems();
      return AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        backgroundColor: AppColors.kBlack,
        elevation: 8,
        shadowColor: AppColors.black30,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        titleSpacing: 24,
        title: Row(children: [AvatarWidget(), const SizedBox(width: 18)]),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < navigationItems.length; i++)
                _DesktopNavButton(
                  label: navigationItems[i].title,
                  isActive: _activeIndex == i,
                  onTap: () => _onNavTap(i, navigationItems[i]),
                ),
              const SizedBox(width: 24),
            ],
          ),
        ],
      );
    } else {
      // Mobile/Tablet: Default AppBar as before
      return AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        backgroundColor: AppColors.kBlack,
        elevation: 8,
        shadowColor: AppColors.black30,
        toolbarHeight: isMobile ? 65 : (isTablet ? 75 : 80),
        automaticallyImplyLeading: false,
        title: !isDesktop ? AvatarWidget() : null,
        actions: isDesktop
            ? null
            : [
                Tooltip(
                  message: "Open navigation menu",
                  showDuration: const Duration(seconds: 2),
                  waitDuration: const Duration(milliseconds: 500),
                  child: Builder(
                    builder: (context) => _TapMenuIconButton(
                      onTap: () => Scaffold.of(context).openEndDrawer(),
                      isMobile: isMobile,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
      );
    }
  }
}

// Desktop navigation button with hover/active state
class _DesktopNavButton extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DesktopNavButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_DesktopNavButton> createState() => _DesktopNavButtonState();
}

class _DesktopNavButtonState extends State<_DesktopNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color textColor;
    if (widget.isActive) {
      textColor = AppColors.kYellow;
    } else if (_isHovered) {
      textColor = AppColors.yellow80;
    } else {
      textColor = AppColors.white90;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: widget.isActive
              ? BoxDecoration(
                  color: AppColors.yellow10,
                  borderRadius: BorderRadius.circular(10),
                )
              : null,
          child: Text(
            widget.label,
            style: AppTextStyles.appBarHeading.copyWith(
              color: textColor,
              fontWeight: widget.isActive ? FontWeight.bold : FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced tap menu icon button with better animations
class _TapMenuIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isMobile;

  const _TapMenuIconButton({required this.onTap, required this.isMobile});

  @override
  State<_TapMenuIconButton> createState() => _TapMenuIconButtonState();
}

class _TapMenuIconButtonState extends State<_TapMenuIconButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _isPressed ? AppColors.yellow20 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isPressed ? AppColors.yellow50 : AppColors.white20,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onHighlightChanged: (pressed) {
            setState(() => _isPressed = pressed);
            if (pressed) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }
          },
          onTap: widget.onTap,
          splashColor: AppColors.yellow30,
          highlightColor: AppColors.yellow10,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(widget.isMobile ? 12 : 14),
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 3.14159,
                  child: Icon(
                    Icons.menu,
                    size: widget.isMobile ? 26 : 28,
                    color: _isPressed ? AppColors.kYellow : Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Professional Scroll to Top Button
class _ScrollToTopButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ScrollToTopButton({required this.onTap});

  @override
  State<_ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<_ScrollToTopButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.kBlack,
                  AppColors.kBlack.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black30,
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.kYellow.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: _isPressed ? AppColors.kYellow : AppColors.white20,
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                onTap: () {
                  widget.onTap();
                  _bounceController.forward().then((_) {
                    _bounceController.reverse();
                  });
                },
                onHighlightChanged: (pressed) {
                  setState(() => _isPressed = pressed);
                },
                borderRadius: BorderRadius.circular(28),
                splashColor: AppColors.yellow30,
                highlightColor: AppColors.yellow20,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 32,
                    color: _isPressed ? AppColors.kYellow : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
