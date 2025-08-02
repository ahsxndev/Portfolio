import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/core/widgets/interactive_widgets.dart';

class ServiceCard extends StatefulWidget {
  final String number;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final Color cardColor;
  final Color numberBadgeColor;
  final Color buttonColor;
  final Color buttonTextColor;

  const ServiceCard({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    this.buttonText = 'Learn More',
    this.onButtonPressed,
    this.cardColor = AppColors.kPurple,
    this.numberBadgeColor = AppColors.kGreen,
    this.buttonColor = AppColors.kYellow,
    this.buttonTextColor = Colors.black,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _shadowAnimation = Tween<double>(begin: 8.0, end: 16.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
    final bool isTablet = Responsive.isTablet(context);
    final bool isActive = _isHovered || _isPressed;

    final double cardWidth = isMobile ? 260 : (isTablet ? 300 : 320);
    final double cardHeight = isMobile ? 320 : (isTablet ? 360 : 380);
    final double titleFontSize = isMobile ? 18 : (isTablet ? 22 : 24);
    final double descFontSize = isMobile ? 14 : (isTablet ? 15 : 16);
    final double buttonFontSize = isMobile ? 16 : 18;

    return InteractiveServiceCard(
      onTap: widget.onButtonPressed,
      onStateChange: (isActive) {
        if (mounted) {
          setState(() {
            _isHovered = isActive;
            _isPressed = isActive;
          });
          if (isActive) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Enhanced shadow (black) background layer
                Positioned(
                  top: isMobile ? 6 : 8,
                  left: isMobile ? 6 : 8,
                  child: Container(
                    width: cardWidth,
                    height: cardHeight,
                    decoration: BoxDecoration(
                      color: AppColors.kBlack,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),

                // Foreground card with enhanced styling
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.cardColor,
                        AppColors.withCustomOpacity(widget.cardColor, 0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x26000000),
                        blurRadius: _shadowAnimation.value,
                        offset: Offset(0, _shadowAnimation.value / 2),
                      ),
                      if (isActive)
                        BoxShadow(
                          color: AppColors.white20,
                          blurRadius: 20,
                          offset: const Offset(0, 0),
                        ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 20 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isMobile ? 36 : 44),

                        // Service Title
                        Text(
                          widget.title,
                          style: GoogleFonts.poppins(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                                color: AppColors.black30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: isMobile ? 16 : 20),

                        // Service Description
                        Expanded(
                          child: Text(
                            widget.description,
                            style: GoogleFonts.poppins(
                              fontSize: descFontSize,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xF0FFFFFF), // 95% white
                              height: 1.6,
                            ),
                          ),
                        ),

                        SizedBox(height: isMobile ? 16 : 20),

                        // Action Button
                        InteractiveButton(
                          onTap: widget.onButtonPressed,
                          scaleFactor: 0.98,
                          child: Container(
                            width: double.infinity,
                            height: isMobile ? 48 : 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isActive
                                    ? [
                                        AppColors.kGreen,
                                        AppColors.withCustomOpacity(
                                          AppColors.kGreen,
                                          0.8,
                                        ),
                                      ]
                                    : [
                                        widget.buttonColor,
                                        AppColors.withCustomOpacity(
                                          widget.buttonColor,
                                          0.9,
                                        ),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isActive
                                    ? AppColors.white30
                                    : AppColors.black20,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black20,
                                  blurRadius: isActive ? 8 : 4,
                                  offset: Offset(0, isActive ? 4 : 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.buttonText,
                                    style: GoogleFonts.poppins(
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? Colors.white
                                          : widget.buttonTextColor,
                                    ),
                                  ),
                                  if (isActive) ...[
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: buttonFontSize,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Enhanced Badge Number
                Positioned(
                  top: -28,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: isMobile ? 52 : 56,
                      height: isMobile ? 52 : 56,
                      decoration: BoxDecoration(
                        color: widget.numberBadgeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          widget.number,
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 24 : 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                                color: AppColors.black50,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ), // Close InteractiveServiceCard
    );
  }
}
