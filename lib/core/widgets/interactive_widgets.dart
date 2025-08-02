import 'package:flutter/material.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';

/// A widget that provides interactive states for both desktop (hover) and mobile (tap)
/// This ensures consistent UX across all platforms
class InteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Function(bool)? onHoverChange;
  final Function(bool)? onTapChange;
  final bool enableHover;
  final bool enableTap;
  final Duration animationDuration;
  final Curve animationCurve;

  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.onHoverChange,
    this.onTapChange,
    this.enableHover = true,
    this.enableTap = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  bool _isTapped = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _handleHoverChange(bool isHovered) {
    if (!widget.enableHover) return;

    setState(() {
      _isHovered = isHovered;
    });

    widget.onHoverChange?.call(isHovered);
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enableTap) return;

    setState(() {
      _isTapped = true;
    });

    widget.onTapChange?.call(true);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enableTap) return;

    setState(() {
      _isTapped = false;
    });

    widget.onTapChange?.call(false);
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (!widget.enableTap) return;

    setState(() {
      _isTapped = false;
    });

    widget.onTapChange?.call(false);
  }

  bool get isActive {

    return _isHovered || _isTapped;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    // Wrap with gesture detector for tap handling
    if (widget.enableTap) {
      child = GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: child,
      );
    }

    // Wrap with mouse region for hover handling (desktop only)
    if (widget.enableHover) {
      child = MouseRegion(
        onEnter: (_) => _handleHoverChange(true),
        onExit: (_) => _handleHoverChange(false),
        child: child,
      );
    }

    return child;
  }
}

/// A specialized interactive widget for project cards
class InteractiveProjectCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final Function(bool isActive)? onStateChange;
  final bool showActiveIndicator;

  const InteractiveProjectCard({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onStateChange,
    this.showActiveIndicator = false,
  });

  @override
  State<InteractiveProjectCard> createState() => _InteractiveProjectCardState();
}

class _InteractiveProjectCardState extends State<InteractiveProjectCard>
    with TickerProviderStateMixin {
  bool _isActive = false;
  bool _isMobile = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
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

  void _handleActiveChange(bool isActive) {
    if (_isActive == isActive) return;

    setState(() {
      _isActive = isActive;
    });

    if (isActive) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }

    widget.onStateChange?.call(isActive);
  }

  void _handleTap() {
    // Provide haptic feedback on mobile
    if (_isMobile) {
      // You can add haptic feedback here if needed
      // HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  void _handleDoubleTap() {
    if (_isMobile) {
      // Double tap shows additional info on mobile
      widget.onDoubleTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Stack(
            children: [
              InteractiveCard(
                onTap: _handleTap,
                onHoverChange: _handleActiveChange,
                onTapChange: _handleActiveChange,
                child: GestureDetector(
                  onDoubleTap: _handleDoubleTap,
                  child: widget.child,
                ),
              ),

              // Active indicator for mobile
              if (widget.showActiveIndicator && _isActive && _isMobile)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// A specialized interactive widget for service cards
class InteractiveServiceCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Function(bool isActive)? onStateChange;
  final Duration holdDuration;

  const InteractiveServiceCard({
    super.key,
    required this.child,
    this.onTap,
    this.onStateChange,
    this.holdDuration = const Duration(milliseconds: 500),
  });

  @override
  State<InteractiveServiceCard> createState() => _InteractiveServiceCardState();
}

class _InteractiveServiceCardState extends State<InteractiveServiceCard>
    with TickerProviderStateMixin {
  bool _isActive = false;
  bool _isMobile = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isMobile = Responsive.isMobile(context);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleActiveChange(bool isActive) {
    if (_isActive == isActive) return;

    setState(() {
      _isActive = isActive;
    });

    if (isActive && _isMobile) {
      // Start pulse animation on mobile for visual feedback
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }

    widget.onStateChange?.call(isActive);
  }

  void _handleTap() {
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isActive && _isMobile ? _pulseAnimation.value : 1.0,
          child: InteractiveCard(
            onTap: _handleTap,
            onHoverChange: _handleActiveChange,
            onTapChange: _handleActiveChange,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// A simple interactive button with consistent behavior
class InteractiveButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final double scaleFactor;

  const InteractiveButton({
    super.key,
    required this.child,
    this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.scaleFactor = 0.95,
  });

  @override
  State<InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton>
    with TickerProviderStateMixin {
  bool _isActive = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleFactor)
        .animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleActiveChange(bool isActive) {
    setState(() {
      _isActive = isActive;
    });

    if (isActive) {
      _scaleController.forward();
    } else {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: InteractiveCard(
            onTap: widget.onTap,
            onHoverChange: _handleActiveChange,
            onTapChange: _handleActiveChange,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _isActive
                    ? (widget.activeColor ??
                          AppColors.withCustomOpacity(Colors.blue, 0.1))
                    : (widget.inactiveColor ?? Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
