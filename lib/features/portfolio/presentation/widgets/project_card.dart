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
  bool _isCodeButtonHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _overlayAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _overlayAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
        // Show error message if URL can't be launched
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch $url'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening URL: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double cardHeight = isMobile ? 250 : 360;
    final double borderRadius = isMobile ? 16 : 24;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: Container(
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered ? AppColors.black15 : AppColors.black08,
                    blurRadius: _isHovered ? 20 : 12,
                    offset: Offset(0, _isHovered ? 8 : 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.yellow10,
                          image: widget.project.imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: AssetImage(widget.project.imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: widget.project.imageUrl.isEmpty
                            ? Container(
                                color: AppColors.yellow30,
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 48,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),

                    // Static bottom gradient (always visible)
                    if (!_isHovered)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.black60,
                                AppColors.black80,
                              ],
                              stops: const [0.0, 0.7, 1.0],
                            ),
                          ),
                        ),
                      ),

                    // Hover Overlay
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(
                                0,
                                0,
                                0,
                                _overlayAnimation.value * 0.7,
                              ),
                              Color.fromRGBO(
                                0,
                                0,
                                0,
                                _overlayAnimation.value * 0.9,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Content
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.all(isMobile ? 16 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hover content at top
                            if (_isHovered) ...[
                              _buildProjectIcon(context),
                              const SizedBox(height: 16),
                            ],

                            // Spacer
                            const Spacer(),

                            // Title section - Always visible
                            _buildProjectTitle(context),

                            // Additional hover content
                            if (_isHovered) ...[
                              const SizedBox(height: 12),
                              _buildProjectDescription(context),
                              const SizedBox(height: 16),
                              _buildTechnologies(context),
                              const SizedBox(height: 16),
                              _buildActionButtons(context),
                            ] else ...[
                              const SizedBox(height: 8),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectIcon(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double iconSize = isMobile ? 48 : 64;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        color: AppColors.kYellow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: widget.project.iconUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.project.iconUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _getFallbackIcon(),
              ),
            )
          : _getFallbackIcon(),
    );
  }

  Widget _getFallbackIcon() {
    // Show specific icon based on project title
    IconData iconData;

    if (widget.project.title.toLowerCase().contains('notes')) {
      iconData = Icons.note_alt;
    } else if (widget.project.title.toLowerCase().contains('voice') ||
        widget.project.title.toLowerCase().contains('ai')) {
      iconData = Icons.mic;
    } else if (widget.project.title.toLowerCase().contains('quran') ||
        widget.project.title.toLowerCase().contains('qur')) {
      iconData = Icons.menu_book;
    } else if (widget.project.title.toLowerCase().contains('instagram')) {
      iconData = Icons.camera_alt;
    } else if (widget.project.title.toLowerCase().contains('covid') ||
        widget.project.title.toLowerCase().contains('tracker')) {
      iconData = Icons.coronavirus;
    } else {
      iconData = Icons.code;
    }

    return Icon(iconData, color: Colors.black, size: 32);
  }

  Widget _buildProjectTitle(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: GoogleFonts.montserrat(
        fontSize: isMobile ? 20 : 28,
        fontWeight: FontWeight.w800,
        color: _isHovered ? AppColors.kYellow : Colors.white,
      ),
      child: Text(
        widget.project.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildProjectDescription(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Text(
      widget.project.description,
      style: GoogleFonts.montserrat(
        fontSize: isMobile ? 14 : 16,
        color: AppColors.white90,
        height: 1.4,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTechnologies(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: widget.project.technologies.take(3).map((tech) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.yellow20,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.yellow50),
          ),
          child: Text(
            tech,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.kYellow,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (widget.project.githubUrl != null) _buildCodeButton(context),
      ],
    );
  }

  Widget _buildCodeButton(BuildContext context) {
    return Tooltip(
      message: "View source code on GitHub",
      showDuration: const Duration(seconds: 2),
      waitDuration: const Duration(milliseconds: 500),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isCodeButtonHovered = true),
        onExit: (_) => setState(() => _isCodeButtonHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isCodeButtonHovered = true),
          onTapUp: (_) => setState(() => _isCodeButtonHovered = false),
          onTapCancel: () => setState(() => _isCodeButtonHovered = false),
          onTap: () => _launchUrl(widget.project.githubUrl!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _isCodeButtonHovered
                  ? AppColors.kYellow
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.kYellow, width: 2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.code,
                    key: ValueKey(_isCodeButtonHovered),
                    size: 18,
                    color: _isCodeButtonHovered
                        ? Colors.black
                        : AppColors.kYellow,
                  ),
                ),
                const SizedBox(width: 6),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isCodeButtonHovered
                        ? Colors.black
                        : AppColors.kYellow,
                  ),
                  child: const Text('View Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
