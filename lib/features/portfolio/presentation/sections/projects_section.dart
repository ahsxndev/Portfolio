import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/features/portfolio/data/projects_data.dart';
import 'package:myfolio/core/config/social_links_config.dart';
import '../widgets/project_card.dart';
import '../widgets/mobile_project_card.dart'; // This should contain both MobileProjectCard and MobileProjectCarousel

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorAnimation =
        ColorTween(begin: AppColors.kBlack, end: AppColors.kYellow).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final projects = ProjectsData.projects;

    return Container(
      width: double.infinity,
      color: AppColors.kYellow,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 1200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Section Title
                _buildSectionTitle(context),
                SizedBox(height: isMobile ? 40 : 60),

                // Projects Grid
                if (isMobile)
                  MobileProjectCarousel(projects: projects)
                else
                  _buildDesktopLayout(context, projects),

                SizedBox(height: isMobile ? 40 : 60),

                // See More Button
                _buildSeeMoreButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Column(
      children: [
        Text(
          'My Projects',
          style: GoogleFonts.montserrat(
            fontSize: isMobile ? 32 : 52,
            fontWeight: FontWeight.w800,
            color: AppColors.kBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: isMobile ? 60 : 100,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.kBlack,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Here are some of my recent projects that showcase my skills and experience.',
          style: GoogleFonts.montserrat(
            fontSize: isMobile ? 16 : 20,
            color: AppColors.black80,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, List projects) {
    final double spacing = 32;

    return Column(
      children: [
        // First Row - 2 projects
        Row(
          children: [
            Expanded(child: ProjectCard(project: projects[0])),
            SizedBox(width: spacing),
            Expanded(child: ProjectCard(project: projects[1])),
          ],
        ),
        SizedBox(height: spacing),

        // Second Row - 2 projects
        Row(
          children: [
            Expanded(child: ProjectCard(project: projects[2])),
            SizedBox(width: spacing),
            Expanded(child: ProjectCard(project: projects[3])),
          ],
        ),
        SizedBox(height: spacing),

        // Third Row - 1 project centered
        Row(
          children: [
            const Expanded(child: SizedBox()),
            Expanded(flex: 2, child: ProjectCard(project: projects[4])),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildSeeMoreButton(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        _animationController.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        _animationController.reverse();
      },
      child: Tooltip(
        message: "View all my projects on GitHub",
        showDuration: const Duration(seconds: 2),
        waitDuration: const Duration(milliseconds: 500),
        child: GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(Uri.parse(SocialLinksConfig.github))) {
              await launchUrl(Uri.parse(SocialLinksConfig.github));
            }
          },
          child: AnimatedBuilder(
            animation: _colorAnimation,
            builder: (context, child) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 32,
                  vertical: isMobile ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: _isHovered ? AppColors.kBlack : Colors.transparent,
                  border: Border.all(color: AppColors.kBlack, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility,
                      color: _isHovered ? AppColors.kYellow : AppColors.kBlack,
                      size: isMobile ? 20 : 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'See More',
                      style: GoogleFonts.montserrat(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        color: _isHovered
                            ? AppColors.kYellow
                            : AppColors.kBlack,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
