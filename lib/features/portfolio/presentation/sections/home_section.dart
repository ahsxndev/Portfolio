import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/app_text_styles.dart';
import 'package:myfolio/features/portfolio/presentation/widgets/image_box.dart';
import 'package:myfolio/core/config/user_info_config.dart';

import 'package:myfolio/core/constants/responsive.dart';
import '../widgets/custom_button_row.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 30 : 60,
        horizontal: isMobile ? 24 : 24,
      ),
      width: double.infinity,
      child: isMobile
          ? Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // ✅ Left align for mobile
              children: [
                _TextContent(isMobile: true),
                const SizedBox(height: 40),
                // ✅ Show image only on mobile in home section
                Center(child: const ImageBox()),
                const SizedBox(height: 32),
                // ✅ Only ONE button row - at the bottom on mobile
                const CustomButtonRow(isMobile: true),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _TextContent(isMobile: false),
                  ),
                ),
                const SizedBox(width: 40),
                const ImageBox(),
              ],
            ),
    );
  }
}

class _TextContent extends StatelessWidget {
  final bool isMobile;

  const _TextContent({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // ✅ Always start-aligned
      children: [
        // Mobile-optimized heading
        Text(
          'Hello,\nI\'m ${UserInfoConfig.firstName}',
          style: isMobile
              ? AppTextStyles.heading.copyWith(
                  color: AppColors.kBlack,
                  height: 1.1,
                  fontSize: 48, // Better mobile size
                )
              : AppTextStyles.heading.copyWith(
                  color: AppColors.kBlack,
                  height: 1.1,
                ),
        ),
        const SizedBox(height: 20),

        // Enhanced animated text section - better mobile layout
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_right_rounded,
              color: AppColors.kBlack,
              size: isMobile ? 32 : 34,
            ),
            const SizedBox(width: 12),
            Expanded(
              // ✅ Use Expanded to handle text overflow properly
              child: AnimatedTextKit(
                repeatForever: true,
                pause: const Duration(milliseconds: 1000),
                animatedTexts: [
                  TyperAnimatedText(
                    UserInfoConfig.jobTitle,
                    textStyle: GoogleFonts.montserrat(
                      fontSize: isMobile ? 22 : 25,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF474A57),
                    ),
                    speed: const Duration(milliseconds: 70),
                  ),
                  TyperAnimatedText(
                    'UI/UX Designer',
                    textStyle: GoogleFonts.montserrat(
                      fontSize: isMobile ? 22 : 25,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF474A57),
                    ),
                    speed: const Duration(milliseconds: 70),
                  ),
                  TyperAnimatedText(
                    'Technical Writer',
                    textStyle: GoogleFonts.montserrat(
                      fontSize: isMobile ? 22 : 25,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF474A57),
                    ),
                    speed: const Duration(milliseconds: 70),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ✅ Only show buttons on desktop - NOT on mobile
        if (!isMobile) ...[
          const SizedBox(height: 36),
          const CustomButtonRow(isMobile: false),
        ],
      ],
    );
  }
}
