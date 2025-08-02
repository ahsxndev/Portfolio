import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/core/config/social_links_config.dart';
import 'package:myfolio/core/config/user_info_config.dart';
import '../navigation/navigation_controller.dart';
import 'avatar_widget.dart';

class CustomDrawer extends StatelessWidget {
  final int activeIndex;

  const CustomDrawer({super.key, this.activeIndex = 0});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = Responsive.screenWidth(context);
    final bool isSmallScreen = screenWidth < 500;
    final bool isMobile = Responsive.isMobile(context);
    final bool isTablet = Responsive.isTablet(context);
    final navigationController = NavigationController();

    // Determine drawer width based on device type
    double drawerWidth;
    if (isSmallScreen) {
      drawerWidth = MediaQuery.of(context).size.width * 0.75;
    } else if (isMobile) {
      drawerWidth = MediaQuery.of(context).size.width * 0.65;
    } else if (isTablet) {
      drawerWidth = 350;
    } else {
      drawerWidth = 280;
    }

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        backgroundColor: AppColors.kBlack,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomLeft: Radius.circular(0),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildDrawerHeader(isTablet),
              // Navigation Items
              Expanded(
                child: _buildNavigationItems(
                  context,
                  navigationController,
                  isTablet,
                  isSmallScreen,
                  activeIndex,
                ),
              ),
              // Footer always at the bottom
              _buildDrawerFooter(context, isTablet, isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(255, 255, 255, 0.08),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: isTablet ? 22 : 16),
            // Avatar
            Transform.scale(
              scale: isTablet ? 1.2 : 1.0,
              child: AvatarWidget(fromDrawer: true),
            ),
            SizedBox(height: isTablet ? 18 : 14),
            // Name and Title
            Text(
              UserInfoConfig.fullName,
              style: GoogleFonts.montserrat(
                fontSize: isTablet ? 20 : 16,
                fontWeight: FontWeight.w700,
                color: AppColors.kYellow,
              ),
            ),
            SizedBox(height: isTablet ? 6 : 4),
            Text(
              UserInfoConfig.jobTitle,
              style: GoogleFonts.montserrat(
                fontSize: isTablet ? 16 : 12,
                fontWeight: FontWeight.w400,
                color: AppColors.white80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItems(
    BuildContext context,
    NavigationController navigationController,
    bool isTablet,
    bool isSmallScreen,
    int activeIndex,
  ) {
    final navigationItems = navigationController.getNavigationItems();

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 20 : 16,
        horizontal: isTablet ? 16 : 12,
      ),
      itemCount: navigationItems.length,
      itemBuilder: (context, index) {
        final item = navigationItems[index];
        final isActive = index == activeIndex;
        return _buildNavigationTile(
          context,
          item,
          isTablet,
          isSmallScreen,
          isActive,
        );
      },
    );
  }

  Widget _buildNavigationTile(
    BuildContext context,
    NavigationItem item,
    bool isTablet,
    bool isSmallScreen,
    bool isActive,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: isSmallScreen
            ? 15
            : isTablet
            ? 12
            : 8,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            item.onTap();
            Navigator.of(context).pop(); // Close drawer after navigation
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: AppColors.yellow10,
          highlightColor: AppColors.yellow05,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen
                  ? 20
                  : isTablet
                  ? 20
                  : 16,
              vertical: isSmallScreen
                  ? 16
                  : isTablet
                  ? 16
                  : 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive ? AppColors.kYellow : AppColors.white10,
                width: isActive ? 2 : 1,
              ),
              color: isActive ? AppColors.yellow05 : Colors.transparent,
            ),
            child: Row(
              children: [
                // Icon
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  color: isActive ? AppColors.kYellow : AppColors.kYellow,
                  size: isSmallScreen
                      ? 30
                      : isTablet
                      ? 26
                      : 22,
                ),
                SizedBox(width: isTablet ? 16 : 12),
                // Title
                Expanded(
                  child: Text(
                    item.title,
                    style: GoogleFonts.montserrat(
                      fontSize: isSmallScreen
                          ? 20
                          : isTablet
                          ? 18
                          : 16,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                      color: isActive ? AppColors.kYellow : Colors.white,
                    ),
                  ),
                ),
                // Arrow icon
                Icon(
                  isActive ? Icons.arrow_forward : Icons.arrow_forward_ios,
                  color: isActive ? AppColors.kYellow : AppColors.white40,
                  size: isTablet ? 18 : 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerFooter(
    BuildContext context,
    bool isTablet,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: isTablet ? 24 : 10,
        right: isTablet ? 24 : 10,
        bottom: isTablet ? 18 : 12,
        top: isTablet ? 18 : 12,
      ),
      child: Column(
        children: [
          const Divider(
            color: Color.fromRGBO(255, 255, 255, 0.08),
            thickness: 1,
            height: 16,
          ),
          // Social Media Icons with labels
          if (!isTablet)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialIconWithLabel(
                  icon: FontAwesomeIcons.github,
                  label: "GitHub",
                  isSmallScreen: isSmallScreen,
                  isTablet: isTablet,
                  onTap: () {
                    launchUrl(
                      Uri.parse(SocialLinksConfig.github),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                _buildSocialIconWithLabel(
                  icon: FontAwesomeIcons.google,
                  label: "Gmail",
                  isSmallScreen: isSmallScreen,
                  isTablet: isTablet,
                  onTap: () {
                    launchUrl(Uri.parse("mailto:${SocialLinksConfig.email}"));
                  },
                ),
                _buildSocialIconWithLabel(
                  icon: FontAwesomeIcons.whatsapp,
                  label: "WhatsApp",
                  isSmallScreen: isSmallScreen,
                  isTablet: isTablet,
                  onTap: () {
                    launchUrl(
                      Uri.parse(
                        "https://wa.me/${SocialLinksConfig.phoneWhatsApp.replaceAll('+', '').replaceAll(' ', '')}",
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                _buildSocialIconWithLabel(
                  icon: FontAwesomeIcons.link,
                  label: "Linktree",
                  isSmallScreen: isSmallScreen,
                  isTablet: isTablet,
                  onTap: () {
                    launchUrl(
                      Uri.parse("https://linktr.ee/ahaxn"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              ],
            ),

          SizedBox(height: isTablet ? 12 : 10),
          // Copyright at the very bottom
          Align(
            alignment: Alignment.center,
            child: Text(
              '© 2025 Portfolio',
              style: GoogleFonts.montserrat(
                fontSize: isTablet ? 14 : 11,
                fontWeight: FontWeight.w400,
                color: AppColors.white60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIconWithLabel({
    required IconData icon,
    required String label,
    required bool isTablet,
    required bool isSmallScreen,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: "Open $label",
      showDuration: const Duration(seconds: 2),
      waitDuration: const Duration(milliseconds: 500),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              decoration: BoxDecoration(
                color: AppColors.white05,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.white10, width: 1),
              ),
              child: FaIcon(
                icon,
                color: AppColors.kYellow,
                size: isSmallScreen ? 25 : 20,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: isTablet ? 11 : 9,
                fontWeight: FontWeight.w500,
                color: AppColors.white80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
