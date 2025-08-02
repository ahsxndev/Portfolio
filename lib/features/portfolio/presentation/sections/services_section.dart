import 'package:flutter/material.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/config/user_info_config.dart';

import 'package:myfolio/core/constants/app_text_styles.dart';
import 'package:myfolio/core/constants/responsive.dart';
import '../../../../core/widgets/interactive_widgets.dart';
import '../../../../core/widgets/mobile_touch_feedback.dart';
import '../widgets/service_card.dart';
import '../widgets/service_detail_modal.dart';

class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scrollController.addListener(_updateArrows);

    // Start fade animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _updateArrows();
    });
  }

  void _updateArrows() {
    if (_scrollController.hasClients) {
      setState(() {
        _showLeftArrow = _scrollController.offset > 20;
        _showRightArrow =
            _scrollController.offset <
                _scrollController.position.maxScrollExtent - 20;
      });
    }
  }

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 300,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 300,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateArrows);
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = Responsive.isMobile(context);
    final bool isTablet = Responsive.isTablet(context);
    final bool isSmallScreen = screenWidth < 500;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.kOrange, AppColors.kOrange],
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : (isTablet ? 60 : 130),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Section Title
                  Text(
                    'Services',
                    style: AppTextStyles.heading.copyWith(
                      color: Colors.white,
                      fontSize: isMobile ? 36 : (isTablet ? 42 : 48),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 16 : 24),

                  // Section Description
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: isMobile ? double.infinity : 800,
                    ),
                    child: Text(
                      "Embark on a journey of digital transformation with services that blend design brilliance with cutting-edge development. Let's create experiences that resonate and applications that captivate.",
                      style: AppTextStyles.body.copyWith(
                        color: const Color(0xF0FFFFFF), // 95% white
                        fontSize: isMobile ? 16 : (isTablet ? 17 : 18),
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isMobile ? 40 : 50),

                  // Scroll Hint for Mobile
                  if (isMobile)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white20,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.white30, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.swipe_left,
                            color: AppColors.white80,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Swipe to explore services',
                            style: TextStyle(
                              color: AppColors.white90,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (isMobile) const SizedBox(height: 20),
                ],
              ),
            ),

            // Services Cards Section
            if (!isMobile) ...[
              // Desktop/Tablet: Navigation arrows
              Stack(
                children: [
                  _buildScrollableServices(isMobile, isTablet, isSmallScreen),

                  // Left Arrow
                  if (_showLeftArrow)
                    Positioned(
                      left: 20,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _buildNavigationButton(
                          icon: Icons.chevron_left,
                          onTap: _scrollLeft,
                        ),
                      ),
                    ),

                  // Right Arrow
                  if (_showRightArrow)
                    Positioned(
                      right: 20,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _buildNavigationButton(
                          icon: Icons.chevron_right,
                          onTap: _scrollRight,
                        ),
                      ),
                    ),
                ],
              ),
            ] else ...[
              // Mobile: Just scrollable
              _buildScrollableServices(isMobile, isTablet, isSmallScreen),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableServices(bool isMobile, bool isTablet, bool isSmallScreen) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: 52,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left spacing
            SizedBox(width: isMobile ? 8 : 24),

            // Service Cards
            ...UserInfoConfig.services.asMap().entries.map((entry) {
              final index = entry.key;
              final service = entry.value;

              Widget card = ServiceCard(
                number: '${index + 1}',
                title: service.title,
                description: service.description,
                onButtonPressed: () {
                  // Show detailed service modal
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => ServiceDetailModal(
                      service: service,
                      serviceNumber: index + 1,
                    ),
                  );
                },
              );

              // Wrap with interaction widget:
              if (isSmallScreen) {
                // On small screens: use MobileTouchFeedback for tap, no hover
                card = MobileTouchFeedback(
                  onTap: () => showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => ServiceDetailModal(
                      service: service,
                      serviceNumber: index + 1,
                    ),
                  ),
                  child: card,
                );
              } else {
                // On desktop/tablet: use InteractiveCard for hover/tap
                card = InteractiveCard(
                  onTap: () => showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => ServiceDetailModal(
                      service: service,
                      serviceNumber: index + 1,
                    ),
                  ),
                  enableHover: true,
                  enableTap: true,
                  child: card,
                );
              }

              return Row(
                children: [
                  SizedBox(
                    width: isMobile ? 280 : (isTablet ? 320 : 350),
                    child: card,
                  ),
                  if (index < UserInfoConfig.services.length - 1)
                    SizedBox(width: isMobile ? 20 : (isTablet ? 24 : 32)),
                ],
              );
            }),

            // Right spacing
            SizedBox(width: isMobile ? 8 : 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.white90,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.black30,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: AppColors.kOrange, size: 28),
        ),
      ),
    );
  }
}