import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final bool isContact;
  final String? tooltip;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = 125,
    this.isContact = false,
    this.tooltip,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 500;
    final bool isMobile = Responsive.isMobile(context);
    final bool isContact = widget.isContact;

    final double offset = _isPressed ? 4 : 0;

    final double height = isContact
        ? (isSmallScreen ? 42 : (isMobile ? 50 : 70))
        : (isSmallScreen ? 44 : 50);

    final double fontSize = isContact
        ? (isSmallScreen ? 22 : (isMobile ? 30 : 40))
        : (isSmallScreen ? 18 : 25);

    final double shadowOffset = isContact
        ? (isSmallScreen ? 4 : 6)
        : (isSmallScreen ? 3 : 5);

    final Color fillColor = isContact
        ? (_isHovered || _isPressed ? AppColors.kPurple : AppColors.kYellow)
        : (_isHovered || _isPressed ? Colors.white : AppColors.kBlack);

    final Color textColor = isContact
        ? (_isHovered || _isPressed ? Colors.white : AppColors.kBlack)
        : (_isHovered || _isPressed ? AppColors.kBlack : Colors.white);

    return MouseRegion(
      onEnter: (_) => _updateHover(true),
      onExit: (_) => _updateHover(false),
      child: Tooltip(
        message: widget.tooltip ?? widget.text,
        showDuration: const Duration(seconds: 2),
        waitDuration: const Duration(milliseconds: 500),
        child: GestureDetector(
          onTapDown: (_) {
            if (!mounted) return;
            setState(() => _isPressed = true);
          },
          onTapUp: (_) {
            if (!mounted) return;
            setState(() => _isPressed = false);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) widget.onTap();
            });
          },
          onTapCancel: () {
            if (!mounted) return;
            setState(() => _isPressed = false);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double buttonWidth = widget.width == double.infinity
                  ? constraints.maxWidth
                  : (widget.width ?? 125);

              return SizedBox(
                height: height + shadowOffset,
                width: buttonWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      top: shadowOffset,
                      left: isContact ? -shadowOffset : shadowOffset,
                      child: Container(
                        height: height,
                        width: buttonWidth,
                        decoration: BoxDecoration(
                          color: isContact ? AppColors.kBlack : AppColors.kTeal,
                          borderRadius: BorderRadius.circular(
                              isContact ? 16 : 12),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      top: _isPressed ? shadowOffset : 0,
                      left: _isPressed
                          ? (isContact ? -shadowOffset : shadowOffset)
                          : (isContact ? -offset : offset),
                      child: Container(
                        height: height,
                        width: buttonWidth,
                        decoration: BoxDecoration(
                          color: fillColor,
                          borderRadius: BorderRadius.circular(
                              isContact ? 16 : 12),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 180),
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                              color: textColor,
                            ),
                            child: Text(widget.text),
                          ),
                        ),
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

  void _updateHover(bool hovering) {
    if (!mounted) return;
    setState(() {
      _isHovered = hovering;
      if (!hovering) _isPressed = false;
    });
  }
}
