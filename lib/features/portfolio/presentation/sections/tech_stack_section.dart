import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/core/constants/app_text_styles.dart';

// ==========================================
// DATA MODEL FOR TECH STACK
// ==========================================
class TechCategory {
  final String title;
  final List<TechItem> items;
  TechCategory({required this.title, required this.items});
}

class TechItem {
  final String name;
  final IconData icon;
  TechItem({required this.name, required this.icon});
}

// ==========================================
// THE WIDGET
// ==========================================
class TechStackSection extends StatelessWidget {
  const TechStackSection({super.key});

  static final List<TechCategory> techCategories = [
    TechCategory(
      title: "Mobile & Web Development",
      items: [
        TechItem(name: "Flutter", icon: FontAwesomeIcons.flutter),
        TechItem(name: "Dart", icon: Icons.code),
      ],
    ),
    TechCategory(
      title: "AI, ML & Data Science",
      items: [
        TechItem(name: "Python", icon: FontAwesomeIcons.python),
        TechItem(name: "Machine Learning", icon: FontAwesomeIcons.brain),
        TechItem(name: "NumPy", icon: Icons.grid_on),
        TechItem(name: "Pandas", icon: Icons.dataset),
        TechItem(name: "Scikit-learn", icon: Icons.model_training),
        TechItem(name: "Gemini API", icon: Icons.auto_awesome),
      ],
    ),
    TechCategory(
      title: "Languages & Databases",
      items: [
        TechItem(name: "C++", icon: Icons.terminal),
        TechItem(name: "C#", icon: Icons.integration_instructions),
        TechItem(name: "SQL", icon: FontAwesomeIcons.database),
      ],
    ),
    TechCategory(
      title: "Backend & Tools",
      items: [
        TechItem(name: "Firebase", icon: FontAwesomeIcons.fire),
        TechItem(name: "REST APIs", icon: Icons.api),
        TechItem(name: "Postman", icon: Icons.send),
        TechItem(name: "GEE", icon: FontAwesomeIcons.earthAmericas),
      ],
    ),
    TechCategory(
      title: "Architecture & Concepts",
      items: [
        TechItem(name: "Clean Architecture", icon: Icons.architecture),
        TechItem(name: "OOP", icon: Icons.category),
        TechItem(name: "Data Structures", icon: Icons.account_tree),
      ],
    ),
    TechCategory(
      title: "Design & Version Control",
      items: [
        TechItem(name: "Figma", icon: FontAwesomeIcons.figma),
        TechItem(name: "GitHub", icon: FontAwesomeIcons.github),
        TechItem(name: "Notion", icon: FontAwesomeIcons.n),
        TechItem(name: "VS Code", icon: FontAwesomeIcons.laptopCode),
        TechItem(name: "Android Studio", icon: FontAwesomeIcons.android),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalMargin = isMobile ? 20 : 50;
    final double contentWidth = screenWidth - (horizontalMargin * 2);

    return Column(
      children: [
        // Less space before the section starts on mobile
        SizedBox(height: isMobile ? 20 : 80),
        Container(
          width: double.infinity,
          color: const Color(0xFF1A1A1A),
          child: Center(
            child: Container(
              width: contentWidth,
              constraints: const BoxConstraints(maxWidth: 1200),
              // Tighter vertical padding for the dark container on mobile
              padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 100),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 50),
              ...techCategories.map((category) => _buildCategory(category)),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 4,
          child: Center(
            child: Image.asset(
              'assets/images/coding_illustration.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.computer,
                size: 200,
                color: AppColors.white20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        // Reduced gap after header
        SizedBox(height: isMobile ? 25 : 40),

        // Tech categories
        ...techCategories.map((category) => _buildCategory(category)),

        // Small gap before final illustration
        SizedBox(height: isMobile ? 15 : 40),

        Center(
          child: Image.asset(
            'assets/images/coding_illustration.png',
            height: isMobile ? 200 : 250,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tech Stack',
          style: AppTextStyles.heading.copyWith(
            color: AppColors.kYellow,
            fontSize: 36,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Change is inevitable, so I keep on exploring new technology, learn it in a minimal possible way and then build something out of it to see how well I did :)",
          style: AppTextStyles.body.copyWith(
            color: const Color(0xE6FFFFFF),
            height: 1.6,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(TechCategory category) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.title,
            style: GoogleFonts.montserrat(
              color: AppColors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: category.items.map((item) => _TechChip(item: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatefulWidget {
  final TechItem item;
  const _TechChip({required this.item});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.kYellow.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isHovered ? AppColors.kYellow : AppColors.kYellow.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.item.icon,
              size: 16,
              color: AppColors.kYellow,
            ),
            const SizedBox(width: 8),
            Text(
              widget.item.name,
              style: GoogleFonts.montserrat(
                color: AppColors.kYellow,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}