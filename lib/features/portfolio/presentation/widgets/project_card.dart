import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/features/portfolio/models/project_model.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    // On mobile, we force the "expanded" state so users can always see/tap the buttons
    final bool isExpanded = isMobile || _isHovered;

    final double cardHeight = isMobile ? 380 : 400;
    final double borderRadius = 20.0;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.kBlack.withValues(alpha: _isHovered ? 0.3 : 0.1),
                  blurRadius: _isHovered ? 30 : 15,
                  offset: Offset(0, _isHovered ? 15 : 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Zooming Background Image
                  Transform.scale(
                    scale: isMobile ? 1.0 : _scaleAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.kBlack,
                        image: widget.project.imageUrl.isNotEmpty
                            ? DecorationImage(
                          image: AssetImage(widget.project.imageUrl),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                    ),
                  ),

                  // 2. Premium Gradient Overlay
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.kBlack.withValues(alpha: isExpanded ? 0.8 : 0.5),
                          AppColors.kBlack.withValues(alpha: isExpanded ? 1.0 : 0.9),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),

                  // 3. Content (Bottom Aligned)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tech Stack Chips (Always Visible)
                          _buildTechnologies(context),
                          const SizedBox(height: 12),

                          // Title (Always Visible)
                          Text(
                            widget.project.title,
                            style: GoogleFonts.montserrat(
                              fontSize: isMobile ? 22 : 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Animated Details (Description + Buttons)
                          ClipRect(
                            child: Transform.translate(
                              offset: Offset(0, isMobile ? 0 : _slideAnimation.value),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: isExpanded ? 1.0 : 0.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.project.description,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        color: Colors.white.withValues(alpha: 0.8),
                                        height: 1.5,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 20),
                                    _buildActionButtons(context),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTechnologies(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.project.technologies.take(3).map((tech) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.kYellow.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.kYellow.withValues(alpha: 0.5)),
          ),
          child: Text(
            tech,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.kYellow,
              letterSpacing: 0.5,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        if (widget.project.liveUrl != null && widget.project.liveUrl!.isNotEmpty)
          _buildButton(
            title: 'Live Preview',
            icon: Icons.open_in_new,
            isPrimary: true,
            onTap: () => _launchUrl(widget.project.liveUrl!),
          ),
        if (widget.project.githubUrl != null && widget.project.githubUrl!.isNotEmpty)
          _buildButton(
            title: 'View Code',
            icon: Icons.code,
            isPrimary: false,
            onTap: () => _launchUrl(widget.project.githubUrl!),
          ),
      ],
    );
  }

  // Reusable Button Builder for consistent design
  Widget _buildButton({
    required String title,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        hoverColor: isPrimary ? Colors.white.withValues(alpha: 0.2) : AppColors.kYellow.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.kYellow : Colors.transparent,
            border: Border.all(color: AppColors.kYellow, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isPrimary ? AppColors.kBlack : AppColors.kYellow,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? AppColors.kBlack : AppColors.kYellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}