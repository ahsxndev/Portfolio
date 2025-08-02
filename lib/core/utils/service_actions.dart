import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // <-- Required for clipboard
import '../constants/app_colors.dart';
import '../config/user_info_config.dart';

class ServiceActions {
  /// Handle "Get Started" action for a specific service
  static Future<void> handleGetStarted(
      BuildContext context,
      String serviceTitle,
      int serviceNumber,
      ) async {
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Show confirmation dialog first
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Get Started with $serviceTitle',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ready to start your $serviceTitle project?',
              style: TextStyle(color: AppColors.white90),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose how you\'d like to proceed:',
              style: TextStyle(color: AppColors.white70, fontSize: 14),
            ),
          ],
        ),
        actions: isMobile
            ? [
          // Mobile layout - vertical buttons
          SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.email, size: 18),
                    label: const Text('Contact via Email'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getServiceColor(serviceNumber),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _openWhatsApp(context, serviceTitle);
                    },
                    icon: const Icon(Icons.message, size: 18),
                    label: const Text('Contact via WhatsApp'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: AppColors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
            : [
          // Desktop layout - horizontal buttons
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.white70),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop(false);
              _openWhatsApp(context, serviceTitle);
            },
            icon: const Icon(Icons.message, size: 18),
            label: const Text('WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.email, size: 18),
            label: const Text('Email'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getServiceColor(serviceNumber),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _openEmailWithServiceInquiry(context, serviceTitle, serviceNumber);
    }
  }

  /// Open email with pre-filled service inquiry
  static Future<void> _openEmailWithServiceInquiry(
      BuildContext context,
      String serviceTitle,
      int serviceNumber,
      ) async {
    final String email = UserInfoConfig.email;
    final String subject = 'Inquiry: $serviceTitle Service';
    final String body =
    '''
Hello ${UserInfoConfig.fullName},

I'm interested in your $serviceTitle service and would like to discuss my project requirements.

Please let me know:
- Your availability for a consultation
- Estimated timeline and pricing
- Next steps to get started

Looking forward to hearing from you.

Best regards,
[Your Name]
[Your Company/Project]
''';

    final String emailUriString =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    try {
      final uri = Uri.parse(emailUriString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        
        if (context.mounted) {
          _showSuccessSnackbar(context, 'Email client opened successfully!');
        }
      } else {
        // Fallback: Copy contact details to clipboard
        final clipboardText = formatContactDetailsForClipboard(
          name: '[Your Name]', // You may prompt user for their name if available
          senderEmail: '[Your Email]', // You may prompt user for email if available
          message: body,
          serviceType: serviceTitle,
        );
        await Clipboard.setData(ClipboardData(text: clipboardText));
        if (context.mounted) {
          _showSuccessSnackbar(
            context,
            'Could not open email app. Contact details copied to clipboard!',
          );
        }
      }
    } catch (e) {
      // Fallback: Copy contact details to clipboard
      final clipboardText = formatContactDetailsForClipboard(
        name: '[Your Name]', // You may prompt user for their name if available
        senderEmail: '[Your Email]', // You may prompt user for email if available
        message: body,
        serviceType: serviceTitle,
      );
      await Clipboard.setData(ClipboardData(text: clipboardText));
      if (context.mounted) {
        _showSuccessSnackbar(
          context,
          'Could not open email app. Contact details copied to clipboard!',
        );
      }
    }
  }

  /// Fallback: Copy contact details to clipboard
  static String formatContactDetailsForClipboard({
    required String name,
    required String senderEmail,
    required String message,
    String? serviceType,
  }) {
    return '''
=== NEW PORTFOLIO CONTACT ===
Name: $name
Email: $senderEmail
${serviceType != null ? 'Service: $serviceType\n' : ''}
Message: $message

Sent at: ${DateTime.now().toString()}
''';
  }

  /// Open WhatsApp with pre-filled service inquiry
  static Future<void> _openWhatsApp(
      BuildContext context,
      String serviceTitle,
      ) async {
    final message = Uri.encodeComponent('''
Hi ${UserInfoConfig.fullName}! 👋

I'm interested in your *$serviceTitle* service and would like to discuss my project.

Could we schedule a consultation to discuss:
- Project requirements
- Timeline and pricing
- Next steps

Thanks!
    ''');

    // Format phone number (remove any spaces, dashes, etc.)
    String phone = UserInfoConfig.phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!phone.startsWith('+')) {
      phone = '+92$phone';
    }

    final whatsappUrl = 'https://wa.me/$phone?text=$message';

    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(
          Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication,
        );
        if (context.mounted) {
          _showSuccessSnackbar(context, 'WhatsApp opened successfully!');
        }
      } else {
        if (context.mounted) {
          _showErrorSnackbar(
            context,
            'WhatsApp not available. Please install WhatsApp.',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackbar(context, 'Error opening WhatsApp: ${e.toString()}');
      }
    }
  }

  /// Get service color based on service number
  static Color _getServiceColor(int serviceNumber) {
    switch (serviceNumber) {
      case 1:
        return const Color(0xFF2196F3); // Blue
      case 2:
        return const Color(0xFF4CAF50); // Green
      case 3:
        return const Color(0xFF9C27B0); // Purple
      case 4:
        return const Color(0xFFFF9800); // Orange
      case 5:
        return const Color(0xFF009688); // Teal
      default:
        return const Color(0xFFFFD54F); // Yellow
    }
  }

  /// Show error snackbar
  static void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success snackbar
  static void _showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Open contact form with pre-filled service information
  static void openContactFormWithService(
      BuildContext context,
      String serviceTitle,
      ) {
    Navigator.of(context).pushNamed(
      '/contact',
      arguments: {'service': serviceTitle, 'prefill': true},
    );
  }
}