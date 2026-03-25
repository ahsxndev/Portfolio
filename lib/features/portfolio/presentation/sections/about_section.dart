import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/core/constants/app_text_styles.dart';

// 7 Images: Mix of portrait and landscape
final List<String> aboutImages = [
  'assets/images/about1.PNG',
  'assets/images/about8.jpeg',
  'assets/images/about3.jpeg',
  'assets/images/about5.jpeg',
  'assets/images/about6.jpeg',
  'assets/images/about7.jpeg',
  'assets/images/about4.jpeg',
];

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
        padding: EdgeInsets.all(isMobile ? 24 : 40),
        decoration: BoxDecoration(
          color: AppColors.kBlue,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000),
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
            // Desktop/Tablet 7-Image Mosaic View
            const Expanded(
              flex: 11,
              child: _ImageMosaicGallery(isMobile: false),
            ),
            const SizedBox(width: 40),
            Expanded(
              flex: 10,
              child: _AboutText(
                isMobile: false,
                isSmallScreen: isSmallScreen,
              ),
            ),
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
        // Text First on Mobile
        _AboutText(isMobile: true, isSmallScreen: isSmallScreen),
        const SizedBox(height: 32),
        // Then the Scaled-Down Mosaic Gallery
        const _ImageMosaicGallery(isMobile: true),
      ],
    );
  }
}

// ========================================================
// 🖼️ UNIVERSAL MOSAIC GALLERY (7 Images, Asymmetric Grid)
// ========================================================
class _ImageMosaicGallery extends StatelessWidget {
  final bool isMobile;
  const _ImageMosaicGallery({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    // Reduce height and gap sizes for mobile screens
    final double galleryHeight = isMobile ? 320 : 480;
    final double gap = isMobile ? 8 : 12;

    return SizedBox(
      height: galleryHeight,
      child: Column(
        children: [
          // Row 1: Portrait (1 flex) + Landscape (2 flex)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(flex: 1, child: _MosaicImage(aboutImages[0], isMobile)),
                SizedBox(width: gap),
                Expanded(flex: 2, child: _MosaicImage(aboutImages[1], isMobile)),
              ],
            ),
          ),
          SizedBox(height: gap),
          // Row 2: Landscape (2 flex) + Portrait/Landscape (1 flex)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(flex: 2, child: _MosaicImage(aboutImages[2], isMobile)),
                SizedBox(width: gap),
                Expanded(flex: 1, child: _MosaicImage(aboutImages[3], isMobile)),
              ],
            ),
          ),
          SizedBox(height: gap),
          // Row 3: 2 Squares (1 flex each) + 1 Landscape (2 flex)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(flex: 1, child: _MosaicImage(aboutImages[4], isMobile)),
                SizedBox(width: gap),
                Expanded(flex: 1, child: _MosaicImage(aboutImages[5], isMobile)),
                SizedBox(width: gap),
                Expanded(flex: 2, child: _MosaicImage(aboutImages[6], isMobile)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget for the Mosaic images
class _MosaicImage extends StatelessWidget {
  final String imagePath;
  final bool isMobile;
  const _MosaicImage(this.imagePath, this.isMobile);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Slightly smaller border radius for mobile
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ========================================================
// 📝 TEXT, HIGHLIGHTS & QUOTE
// ========================================================
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

        // 🌟 Professional Quote Section
        Container(
          padding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: AppColors.kYellow, width: 4)),
          ),
          child: Text(
            "“Crafting elegant solutions through clean code and modern design.”",
            style: GoogleFonts.montserrat(
              fontSize: isMobile ? 14 : 16,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: const Color(0xE6FFFFFF),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // 🌟 Highlighted Text Body
        RichText(
          text: TextSpan(
            style: AppTextStyles.body.copyWith(
              color: const Color(0xE6FFFFFF),
              fontSize: isMobile ? 15 : 16,
              height: 1.7,
            ),
            children: [
              const TextSpan(text: "I’m a "),
              TextSpan(
                text: "Computer Science student",
                style: TextStyle(color: AppColors.kYellow, fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: " at "),
              TextSpan(
                text: "UET Lahore",
                style: TextStyle(color: AppColors.kYellow, fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ", currently serving as the "),
              TextSpan(
                text: "ACM Web Master",
                style: TextStyle(color: AppColors.kYellow, fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ".\n\nWith over "),
              TextSpan(
                text: "2+ years of experience",
                style: TextStyle(color: AppColors.kYellow, fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                  text: " in mobile app development, I specialize in crafting elegant UI/UX designs and building seamless cross-platform apps with "),
              TextSpan(
                text: "Flutter",
                style: TextStyle(color: AppColors.kYellow, fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                  text: ".\n\nAs a technical writer, I also publish insightful articles on Medium. Dive into my portfolio to explore where creativity meets clean code and modern design."),
            ],
          ),
        ),
      ],
    );
  }
}