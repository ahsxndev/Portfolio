import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/app_text_styles.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/core/config/user_info_config.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/social_icons.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double screenWidth = Responsive.screenWidth(context);
    final bool isSmallScreen = screenWidth < 500;

    return Container(
      
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          
          // Top Avatar + Name
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AvatarWidget(),
              const SizedBox(width: 12),
              Text(
                UserInfoConfig.fullName,
                style: AppTextStyles.heading.copyWith(
                  color: AppColors.kBlack,
                  fontSize: isSmallScreen ? 28 : isMobile ? 34 : 40,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Tagline
          Text(
            'I create high-quality apps as quickly as possible. '
            'If you enjoy my work, feel free to reach out. '
            'Let\'s build something great together!',
            textAlign: TextAlign.center,
            style: isMobile
                ? AppTextStyles.subheading.copyWith(
                    color: AppColors.kBlack,
                    fontSize: 20,
                  )
                : AppTextStyles.heading.copyWith(
                    color: AppColors.kBlack,
                    fontSize: 28,
                  ),
          ),

          const SizedBox(height: 28),

          // Social Icons
          const Center(child: SocialIcons(isVertical: false)),

          const SizedBox(height: 40),


          // Responsive Bottom Layout
          LayoutBuilder(
            builder: (_, constraints) {
              final narrow = constraints.maxWidth < 940;

              if (narrow) {
                // Mobile Layout
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLocation(),
                    const SizedBox(height: 12),
                    _buildCopyright(),
                    const SizedBox(height: 12),
                    _buildLinks(context),
                    const SizedBox(height: 30),
                    _buildMadeWithLove(textAlign: TextAlign.center),
                  ],
                );
              } else {
                // Desktop Layout
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLocation(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildCopyright(),
                            const SizedBox(height: 8),
                            _buildMadeWithLove(textAlign: TextAlign.start),
                          ],
                        ),
                        _buildLinks(context),
                      ],
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ---------- Helpers ----------

  Widget _buildLocation() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on, size: 16, color: Colors.black),
        SizedBox(width: 4),
        Text(
          'Okara, Pakistan',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCopyright() {
    return const Text(
      '© ${UserInfoConfig.copyrightYear} All rights reserved by ${UserInfoConfig.fullName}.',
      style: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildMadeWithLove({required TextAlign textAlign}) {
    return Text.rich(
      TextSpan(
        text: 'Developed with ',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        children: [
          const TextSpan(text: '💙', style: TextStyle(fontSize: 16)),
          const TextSpan(text: ' using '),
          TextSpan(
            text: 'Flutter',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
    );
  }

  Widget _buildLinks(BuildContext context) {
    const links = [
      _LinkData(label: 'Guides', url: 'https://docs.flutter.dev'),
      _LinkData(
        label: 'Terms of Use',
        url: 'https://policies.google.com/terms',
      ),
      _LinkData(
        label: 'Privacy Policy',
        url: 'https://policies.google.com/privacy',
      ),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: [
        for (final link in links) _FooterLink(label: link.label, url: link.url),
      ],
    );
  }
}

class _LinkData {
  final String label;
  final String url;

  const _LinkData({required this.label, required this.url});
}

class _FooterLink extends StatelessWidget {
  final String label;
  final String url;

  const _FooterLink({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launch(context),
        child: Text(
          label,
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.blue.shade700,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _launch(BuildContext context) async {
    final uri = Uri.parse(url);
    final ok = await canLaunchUrl(uri);

    if (ok) {
      await launchUrl(
        uri,
        mode: kIsWeb
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open link: $label')),
          );
        }
      });
    }
  }
}
