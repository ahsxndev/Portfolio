import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/features/portfolio/models/project_model.dart';

// ==========================================
// CAROUSEL WIDGET
// ==========================================
class MobileProjectCarousel extends StatefulWidget {
  final List<ProjectModel> projects;
  const MobileProjectCarousel({super.key, required this.projects});

  @override
  State<MobileProjectCarousel> createState() => _MobileProjectCarouselState();
}

class _MobileProjectCarouselState extends State<MobileProjectCarousel> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  bool _isAnyCardFlipped = false;

  static const double fixedCardWidth = 500;
  static const double fixedCardHeight = 300;
  static const double cardGap = 200;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: fixedCardWidth / (fixedCardWidth + cardGap),
    );
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (widget.projects.length > 1) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
        if (_pageController.hasClients && !_isAnyCardFlipped) {
          int nextPage = _currentPage + 1;
          if (nextPage >= widget.projects.length) {
            nextPage = 0;
          }
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentPage = nextPage;
          });
        }
      });
    }
  }

  void _onCardFlipChanged(bool isFlipped, int cardIndex) {
    setState(() {
      _isAnyCardFlipped = isFlipped;
      _currentPage = cardIndex;
    });

    if (isFlipped) {
      _timer?.cancel();
    } else {
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    if (!isMobile) {
      return Column(
        children: widget.projects
            .map(
              (project) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: MobileProjectCard(
              project: project,
              cardWidth: fixedCardWidth,
              cardHeight: fixedCardHeight,
            ),
          ),
        )
            .toList(),
      );
    }
    return SizedBox(
      height: fixedCardHeight,
      width: double.infinity,
      child: Center(
        child: SizedBox(
          width: fixedCardWidth,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.projects.length,
            itemBuilder: (context, index) {
              return AnimatedScale(
                scale: _currentPage == index ? 1.0 : 0.93,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                child: MobileProjectCard(
                  project: widget.projects[index],
                  isFocused: _currentPage == index,
                  onFlipChanged: (isFlipped) =>
                      _onCardFlipChanged(isFlipped, index),
                  cardWidth: fixedCardWidth,
                  cardHeight: fixedCardHeight,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ==========================================
// INDIVIDUAL MOBILE CARD
// ==========================================
class MobileProjectCard extends StatefulWidget {
  final ProjectModel project;
  final bool isFocused;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFlipChanged;
  final double cardWidth;
  final double cardHeight;

  const MobileProjectCard({
    super.key,
    required this.project,
    this.isFocused = true,
    this.onTap,
    this.onFlipChanged,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  State<MobileProjectCard> createState() => _MobileProjectCardState();
}

class _MobileProjectCardState extends State<MobileProjectCard>
    with TickerProviderStateMixin {
  bool _isFlipped = false;
  Timer? _flipBackTimer;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipBackTimer?.cancel();
    _flipController.dispose();
    super.dispose();
  }

  // Robust URL Launcher for Mobile
  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  void _handleCardTap() {
    if (!_isFlipped) {
      setState(() => _isFlipped = true);
      widget.onFlipChanged?.call(true);
      _flipController.forward();

      // Auto flip back after 6 seconds (giving them more time to read/click on mobile)
      _flipBackTimer?.cancel();
      _flipBackTimer = Timer(const Duration(seconds: 6), () {
        if (mounted && _isFlipped) {
          setState(() => _isFlipped = false);
          widget.onFlipChanged?.call(false);
          _flipController.reverse();
        }
      });
    } else {
      setState(() => _isFlipped = false);
      widget.onFlipChanged?.call(false);
      _flipController.reverse();
      _flipBackTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        return Container(
          width: widget.cardWidth,
          height: widget.cardHeight,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
          child: GestureDetector(
            onTap: _handleCardTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.kYellow, width: 2.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_flipAnimation.value * math.pi),
                  child: _flipAnimation.value < 0.5
                      ? _buildFrontCard()
                      : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildBackCard(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFrontCard() {
    return Stack(
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
                child: Icon(Icons.image, size: 32, color: Colors.black54),
              ),
            )
                : null,
          ),
        ),

        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.black50,
                  AppColors.black77,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ),

        // Content
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

                // Title
                Text(
                  widget.project.title,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Technologies
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: widget.project.technologies.take(3).map((tech) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.yellow70),
                      ),
                      child: Text(
                        tech,
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kYellow,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 11),

                // Tap indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.yellow90,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.touch_app,
                        size: 14,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tap for details',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: AppColors.kYellow, width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.kYellow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: widget.project.iconUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  widget.project.iconUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(
                    Icons.code,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              )
                  : const Icon(Icons.code, color: Colors.black, size: 18),
            ),

            const SizedBox(height: 10),

            // Title
            Text(
              widget.project.title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.kYellow,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              widget.project.description,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                color: AppColors.white93,
                height: 1.35,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // Technologies
            Wrap(
              spacing: 6,
              runSpacing: 3,
              children: widget.project.technologies.map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kYellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tech,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            // ACTION BUTTONS (Live + Code)
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // Improved Action Buttons for Mobile
  Widget _buildActionButtons() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        if (widget.project.liveUrl != null && widget.project.liveUrl!.isNotEmpty)
          _buildButton(
            title: 'Live',
            icon: Icons.open_in_new,
            isPrimary: true,
            onTap: () => _launchUrl(widget.project.liveUrl!),
          ),
        if (widget.project.githubUrl != null && widget.project.githubUrl!.isNotEmpty)
          _buildButton(
            title: 'Code',
            icon: Icons.code,
            isPrimary: false,
            onTap: () => _launchUrl(widget.project.githubUrl!),
          ),
      ],
    );
  }

  // Reusable Native Mobile Button
  Widget _buildButton({
    required String title,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Cancel auto-flip when they interact with a button
          _flipBackTimer?.cancel();
          onTap();
        },
        borderRadius: BorderRadius.circular(6),
        splashColor: isPrimary ? Colors.white24 : AppColors.kYellow.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.kYellow : Colors.transparent,
            border: Border.all(color: AppColors.kYellow, width: 1.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isPrimary ? Colors.black : AppColors.kYellow,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? Colors.black : AppColors.kYellow,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}