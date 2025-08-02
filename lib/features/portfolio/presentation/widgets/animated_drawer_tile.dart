import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfolio/core/constants/app_colors.dart';

class AnimatedDrawerTile extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final Duration delay;

  const AnimatedDrawerTile({
    super.key,
    required this.title,
    required this.onTap,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedDrawerTile> createState() => _AnimatedDrawerTileState();
}

class _AnimatedDrawerTileState extends State<AnimatedDrawerTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Add delay if needed (for staggered appearance)
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!mounted) return;
        setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (!mounted) return;
        setState(() => _isHovered = false);
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _offsetAnimation,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: _isHovered ? AppColors.kYellow : Colors.white,
                fontWeight: FontWeight.w600,
              ),
              child: Text(widget.title),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}
