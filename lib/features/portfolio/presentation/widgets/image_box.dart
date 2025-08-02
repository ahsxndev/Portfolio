import 'package:flutter/material.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/features/portfolio/presentation/widgets/social_icons.dart';

class ImageBox extends StatefulWidget {
  final bool isAnimation;
  const ImageBox({super.key, this.isAnimation = false});

  @override
  State<ImageBox> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    // ✅ Responsive sizing based on animation + screen width
    final double width = widget.isAnimation
        ? (isMobile ? screenWidth * 0.7 : screenWidth * 0.3)
        : (isMobile ? 220 : 350);
    final double height = widget.isAnimation
        ? (isMobile ? screenWidth * 0.9 : screenWidth * 0.42)
        : (isMobile ? 280 : 475);

    Widget buildImageBox() {
      return MouseRegion(
        onEnter: (_) {
          if (!mounted) return;
          setState(() => _isHovered = true);
        },
        onExit: (_) {
          if (!mounted) return;
          setState(() => _isHovered = false);
        },
        child: SizedBox(
          width: width + (isMobile && !widget.isAnimation ? 4 : 10),
          height: height + (isMobile && !widget.isAnimation ? 4 : 10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Shadow box
              Positioned(
                left: widget.isAnimation ? 0 : null,
                top: widget.isAnimation ? 0 : null,
                right: widget.isAnimation ? null : 0,
                bottom: widget.isAnimation ? null : 0,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        offset: Offset(4, 6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ),

              // Foreground image
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: widget.isAnimation && _isHovered ? -10 : 0,
                left: widget.isAnimation && _isHovered ? -10 : 0,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: AppColors.kBlack,
                    border: Border.all(color: AppColors.kBlack, width: 2),
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/my_pic.jpg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isMobile) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildImageBox(),
          const SizedBox(width: 16),
          if (!widget.isAnimation) const SocialIcons(isVertical: true),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildImageBox(),
          const SizedBox(width: 40),
          if (!widget.isAnimation) const SocialIcons(isVertical: true),
        ],
      );
    }
  }
}
