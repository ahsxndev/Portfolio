import 'package:flutter/material.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/app_text_styles.dart';
import '../navigation/navigation_controller.dart';

class AppBarButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed; // Made optional since we'll use navigation

  const AppBarButton({super.key, required this.label, this.onPressed});

  @override
  State<AppBarButton> createState() => _AppBarButtonState();
}

class _AppBarButtonState extends State<AppBarButton>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final navigationController = NavigationController();

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _updateHover(true),
      onExit: (_) => _updateHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: _isHovering
                    ? Border.all(color: AppColors.yellow30, width: 1)
                    : null,
                color: _isHovering ? AppColors.yellow10 : Colors.transparent,
              ),
              child: TextButton(
                onPressed: () {
                  if (widget.onPressed != null) {
                    widget.onPressed!();
                  } else {
                    // Use navigation controller to scroll to section
                    navigationController.scrollToSection(widget.label);
                  }
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Add icon based on section
                    Icon(
                      _getIconForSection(widget.label),
                      color: _isHovering ? AppColors.kYellow : Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.label,
                      style: AppTextStyles.appBarHeading.copyWith(
                        color: _isHovering ? AppColors.kYellow : Colors.white,
                        fontWeight: _isHovering
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForSection(String sectionName) {
    switch (sectionName.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'about':
        return Icons.person_outline;
      case 'services':
        return Icons.work_outline;
      case 'projects':
        return Icons.folder_outlined;
      case 'contact':
        return Icons.contact_mail_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  void _updateHover(bool hovering) {
    if (!mounted) return;
    setState(() {
      _isHovering = hovering;
    });

    if (hovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }
}
