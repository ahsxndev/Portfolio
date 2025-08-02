import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/core/constants/app_colors.dart';

/// Provides visual and haptic feedback for mobile touch interactions
class MobileTouchFeedback extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final bool enableHapticFeedback;
  final bool enableVisualFeedback;
  final Duration feedbackDuration;
  final Color? feedbackColor;

  const MobileTouchFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.enableHapticFeedback = true,
    this.enableVisualFeedback = true,
    this.feedbackDuration = const Duration(milliseconds: 200),
    this.feedbackColor,
  });

  @override
  State<MobileTouchFeedback> createState() => _MobileTouchFeedbackState();
}

class _MobileTouchFeedbackState extends State<MobileTouchFeedback>
    with TickerProviderStateMixin {
  bool _isMobile = false;
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: widget.feedbackDuration,
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isMobile = Responsive.isMobile(context);
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_isMobile || !widget.enableVisualFeedback) return;

    _rippleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isMobile) return;

    _rippleController.reverse();

    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (!_isMobile) return;

    _rippleController.reverse();
  }

  void _handleLongPress() {
    if (!_isMobile) return;

    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }

    widget.onLongPress?.call();
  }

  void _handleDoubleTap() {
    if (!_isMobile) return;

    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }

    widget.onDoubleTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMobile) {
      // On desktop, just return the child with regular tap handling
      return GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onDoubleTap: widget.onDoubleTap,
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress: _handleLongPress,
      onDoubleTap: _handleDoubleTap,
      child: Stack(
        children: [
          widget.child,

          // Ripple effect overlay for mobile
          if (widget.enableVisualFeedback)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.withCustomOpacity(
                        (widget.feedbackColor ?? AppColors.kYellow),
                        _rippleAnimation.value * 0.1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// A mobile-optimized card with touch feedback
class MobileOptimizedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? tooltip;
  final bool showPressAnimation;

  const MobileOptimizedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.tooltip,
    this.showPressAnimation = true,
  });

  @override
  State<MobileOptimizedCard> createState() => _MobileOptimizedCardState();
}

class _MobileOptimizedCardState extends State<MobileOptimizedCard>
    with TickerProviderStateMixin {
  bool _isMobile = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isMobile = Responsive.isMobile(context);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handlePressStart() {
    if (!widget.showPressAnimation || !_isMobile) return;

    _scaleController.forward();
  }

  void _handlePressEnd() {
    if (!widget.showPressAnimation || !_isMobile) return;

    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        );
      },
    );

    child = MobileTouchFeedback(
      onTap: () {
        _handlePressEnd();
        widget.onTap?.call();
      },
      onLongPress: widget.onLongPress,
      child: GestureDetector(
        onTapDown: (_) => _handlePressStart(),
        onTapCancel: _handlePressEnd,
        child: child,
      ),
    );

    // Add tooltip for mobile long press
    if (widget.tooltip != null && _isMobile) {
      child = Tooltip(
        message: widget.tooltip!,
        preferBelow: false,
        child: child,
      );
    }

    return child;
  }
}

/// Shows a floating action hint for mobile users
class MobileActionHint extends StatefulWidget {
  final String message;
  final IconData icon;
  final bool show;
  final Duration displayDuration;

  const MobileActionHint({
    super.key,
    required this.message,
    required this.icon,
    required this.show,
    this.displayDuration = const Duration(seconds: 3),
  });

  @override
  State<MobileActionHint> createState() => _MobileActionHintState();
}

class _MobileActionHintState extends State<MobileActionHint>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isMobile = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isMobile = Responsive.isMobile(context);
  }

  @override
  void didUpdateWidget(MobileActionHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show && _isMobile) {
      _fadeController.forward();
      Future.delayed(widget.displayDuration, () {
        if (mounted) {
          _fadeController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMobile) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.black80,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.kYellow, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: AppColors.kYellow, size: 16),
                const SizedBox(width: 8),
                Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
