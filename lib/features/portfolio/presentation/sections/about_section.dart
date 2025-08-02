import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/core/constants/app_text_styles.dart';
import 'package:myfolio/core/config/user_info_config.dart';
import '../widgets/image_box.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    final bool isSmallScreen = screenWidth < 500;

    final double horizontalMargin = isMobile ? 20 : 50;
    final double contentWidth = screenWidth - (horizontalMargin * 2);

    return Center(
      child: Container(
        width: contentWidth,
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        decoration: BoxDecoration(
          color: AppColors.kBlue,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000), // 10% black
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: isMobile
            ? const _MobileLayout()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ImageBox(isAnimation: true),
                  const SizedBox(width: 40),
                  Expanded(child: _AboutText(isMobile: false, isSmallScreen: isSmallScreen,)),
                ],
              ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = Responsive.screenWidth(context);
    final bool isSmallScreen = screenWidth < 500;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AboutText(isMobile: true, isSmallScreen: isSmallScreen),
        SizedBox(height: 18),
        _MobileStatsRow(),
      ],
    );
  }
}

class _AboutText extends StatelessWidget {
  final bool isMobile;
  final bool isSmallScreen;

  const _AboutText({required this.isMobile, required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About me',
          style: AppTextStyles.heading.copyWith(
            color: Colors.white,
            height: 1.2,
            fontSize: isMobile ? 34 : 40,
          ),
        ),
        const SizedBox(height: 16),
        !isMobile
            ? Text(
                UserInfoConfig.skillsDescription,
                style: AppTextStyles.subheading.copyWith(
                  color: AppColors.kYellow,
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: UserInfoConfig.skillsBadges
                    .map((skill) => _SkillBadge(skill, isSmallScreen))
                    .toList(),
              ),
        const SizedBox(height: 24),
        Text(
          "I’m a third-year Computer Science student at UET Lahore with over 1.5 years of experience in mobile app development. I specialize in crafting elegant UI/UX designs and building seamless cross-platform apps with Flutter. As a technical writer, I also publish insightful articles on Medium. Dive into my portfolio to explore where creativity meets clean code and modern design.",
          style: AppTextStyles.body.copyWith(
            color: const Color(0xE6FFFFFF), // 90% white
            fontSize: isMobile ? 16 : null,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _MobileStatsRow extends StatelessWidget {
  const _MobileStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _StatCard('1.5+', 'Years\nExperience')),
        SizedBox(width: 16),
        Expanded(child: _StatCard('30+', 'Projects\nCompleted')),
        SizedBox(width: 16),
        Expanded(child: _StatCard('100%', 'Client\nSatisfaction')),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard(this.number, this.label);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = Responsive.screenWidth(context);
    final bool isSmallScreen = screenWidth < 500;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x33FFFFFF), width: 1),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: GoogleFonts.montserrat(
              fontSize: isSmallScreen? 22 :24,
              fontWeight: FontWeight.w800,
              color: AppColors.kYellow,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: isSmallScreen? 10: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xCCFFFFFF),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillBadge extends StatelessWidget {
  final String skill;
  final bool isSmallScreen;

  const _SkillBadge(this.skill, this.isSmallScreen);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x33FFDD55), // 20% yellow
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x80FFDD55), // 50% yellow
          width: 1,
        ),
      ),
      child: Text(
        skill,
        style: GoogleFonts.montserrat(
          fontSize: isSmallScreen? 12:16,
          fontWeight: FontWeight.w600,
          color: AppColors.kYellow,
        ),
      ),
    );
  }
}
