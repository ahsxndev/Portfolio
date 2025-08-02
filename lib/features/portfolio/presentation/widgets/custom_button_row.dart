import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myfolio/core/config/social_links_config.dart';

import '../../../../core/constants/responsive.dart';
import 'custom_button.dart';

class CustomButtonRow extends StatelessWidget {
  final bool isMobile;

  const CustomButtonRow({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = Responsive.screenWidth(context);
    final bool isSmallScreen = screenWidth < 500;
    final double spacing = isSmallScreen ? 16 : 27;

    return Row(
      mainAxisAlignment: isMobile
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        CustomButton(
          text: 'Hire me',
          onTap: () => _openEmailApp(),
          tooltip: 'Contact me for job opportunities',
        ),
        SizedBox(width: spacing),
        CustomButton(
          text: 'Download CV',
          width: isSmallScreen ? 160 : 210,
          onTap: () => _downloadCV(),
          tooltip: 'Download my resume/CV',
        ),
      ],
    );
  }

  Future<void> _openEmailApp() async {
    final String email = SocialLinksConfig.email;
    final String subject = SocialLinksConfig.emailSubject;
    final String body = SocialLinksConfig.emailBody;

    final String emailUriString =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    try {
      await launchUrl(Uri.parse(emailUriString));
    } catch (e) {
      debugPrint('Could not launch email app: $e');
    }
  }

  Future<void> _downloadCV() async {
    try {
      final Uri url = Uri.parse(SocialLinksConfig.cvDownloadUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not download CV: $e');
    }
  }
}
