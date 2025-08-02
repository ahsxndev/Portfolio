import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myfolio/core/config/social_links_config.dart';

class SocialIcons extends StatelessWidget {
  final bool isVertical;
  final double iconSize;

  const SocialIcons({
    super.key,
    required this.isVertical,
    this.iconSize = 42, // Default for larger screens
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = Responsive.screenWidth(context);
    final bool isSmallScreen = screenWidth < 500;

    final List<_SocialItem> icons = [
      _SocialItem(
        FontAwesomeIcons.instagram,
        Colors.pinkAccent,
        "Follow me on Instagram",
        SocialLinksConfig.instagram,
      ),
      _SocialItem(
        FontAwesomeIcons.xTwitter,
        Colors.black,
        "Follow me on X (Twitter)",
        SocialLinksConfig.twitter,
      ),
      _SocialItem(
        FontAwesomeIcons.linkedinIn,
        Colors.blue[800]!,
        "Connect with me on LinkedIn",
        SocialLinksConfig.linkedin,
      ),
      _SocialItem(
        FontAwesomeIcons.github,
        Colors.black,
        "View my GitHub repositories",
        SocialLinksConfig.github,
      ),
      _SocialItem(
        FontAwesomeIcons.medium,
        Colors.green,
        "Read my articles on Medium",
        SocialLinksConfig.medium,
      ),
    ];

    return Flex(
      direction: isVertical ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: icons
          .map(
            (item) => _HoverableIcon(
          item: item,
          isVertical: isVertical,
          iconSize: iconSize,
          isSmallScreen: isSmallScreen,
        ),
      )
          .toList(),
    );
  }
}

class _SocialItem {
  final IconData icon;
  final Color color;
  final String tooltip;
  final String url;

  _SocialItem(this.icon, this.color, this.tooltip, this.url);
}

class _HoverableIcon extends StatefulWidget {
  final _SocialItem item;
  final bool isVertical;
  final double iconSize;
  final bool isSmallScreen;

  const _HoverableIcon({
    required this.item,
    required this.isVertical,
    required this.iconSize,
    required this.isSmallScreen,
  });

  @override
  State<_HoverableIcon> createState() => _HoverableIconState();
}

class _HoverableIconState extends State<_HoverableIcon> {
  bool _isHovered = false;
  final bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double size = !isMobile ? widget.iconSize + 12 : widget.iconSize;
    final double iconActualSize = !isMobile ? size * 0.5 : size * 0.48;

    final bool showColor = widget.isSmallScreen || _isHovered || _isPressed;

    return MouseRegion(
      onEnter: (_) {
        if (!widget.isSmallScreen) _updateHover(true);
      },
      onExit: (_) {
        if (!widget.isSmallScreen) _updateHover(false);
      },
      child: GestureDetector(
        onTap: () => _launchUrl(widget.item.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(
            horizontal: widget.isVertical ? 0 : 8,
            vertical: widget.isVertical ? 8 : 0,
          ),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              widget.item.icon,
              size: iconActualSize,
              color: showColor
                  ? widget.item.color
                  : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  void _updateHover(bool hovering) {
    if (!mounted) return;
    setState(() => _isHovered = hovering);
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch $urlString: $e');
    }
  }
}