import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../config/emailjs_config.dart';
import '../config/user_info_config.dart';

class EmailService {
  /// ✅ Send email directly using EmailJS REST API
  static Future<bool> sendEmailWithEmailJs({
    required String name,
    required String senderEmail,
    required String message,
    String? serviceType,
    BuildContext? context,
  }) async {
    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

      final body = {
        'service_id': EmailJSConfig.serviceId,
        'template_id': EmailJSConfig.templateId,
        'user_id': EmailJSConfig.userId,
        'accessToken': EmailJSConfig.privateKey,
        'template_params': {
          'name': name,
          'email': senderEmail,
          'message': message,
          'from_name': name,
          'from_email': senderEmail,
          'user_name': name,
          'user_email': senderEmail,
          'sender_name': name,
          'sender_email': senderEmail,
          'reply_to': senderEmail,
          if (serviceType != null) 'service_type': serviceType,
          if (serviceType != null) 'service': serviceType,
        },
      };

      // ignore: avoid_print
      print('=== EmailJS Request Data ===');
      // ignore: avoid_print
      print('Sender Name: $name');
      // ignore: avoid_print
      print('Sender Email: $senderEmail');
      // ignore: avoid_print
      print('Message: $message');
      // ignore: avoid_print
      print('Template Params: ${body['template_params']}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Origin': 'http://localhost',
          'User-Agent': 'Mozilla/5.0',
        },
        body: jsonEncode(body),
      );

      // ignore: avoid_print
      print('EmailJS Status Code: ${response.statusCode}');
      // ignore: avoid_print
      print('EmailJS Response: ${response.body}');

      if (response.statusCode == 200) {
        if (context != null && context.mounted) {
          showSuccessSnackbar(
            context,
            'Your message has been sent successfully!',
          );
        }
        return true;
      } else {
        if (context != null && context.mounted) {
          _showErrorSnackbar(
            context,
            'Failed to send message. Code: ${response.statusCode}',
          );
        }
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('EmailJS Error: $e');
      if (context != null && context.mounted) {
        _showErrorSnackbar(context, 'Error: $e');
      }
      return false;
    }
  }

  /// ✅ Send email using default email client
  static Future<bool> sendEmail({
    required String name,
    required String senderEmail,
    required String message,
    String? serviceType,
    BuildContext? context,
  }) async {
    try {
      final subject = serviceType != null
          ? 'Portfolio Inquiry: $serviceType Service'
          : 'Portfolio Contact Form Message';

      final body =
          '''
Hello ${UserInfoConfig.fullName},

You have received a new message:

=== CONTACT DETAILS ===
Name: $name
Email: $senderEmail
${serviceType != null ? 'Service Interest: $serviceType\n' : ''}

=== MESSAGE ===
$message

=== AUTOMATED SIGNATURE ===
This message was sent through your portfolio contact form.
''';

      final Uri emailUri = Uri.parse(
        'mailto:${UserInfoConfig.email}?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
      );

      final bool launched = await launchUrl(emailUri);

      if (!launched && context != null && context.mounted) {
        _showErrorSnackbar(
          context,
          'No email client found or failed to launch.',
        );
      }

      return launched;
    } catch (e) {
      if (context != null && context.mounted) {
        _showErrorSnackbar(context, 'Error sending email: ${e.toString()}');
      }
      return false;
    }
  }

  /// ✅ Send WhatsApp message with contact details
  static Future<bool> sendWhatsAppMessage({
    required String name,
    required String senderEmail,
    required String message,
    String? serviceType,
    BuildContext? context,
  }) async {
    try {
      final whatsappMessage =
          '''
Hi ${UserInfoConfig.fullName}! 👋

New message from your portfolio:

*Name:* $name
*Email:* $senderEmail
${serviceType != null ? '*Service:* $serviceType\n' : ''}
*Message:* $message

Please respond via email at $senderEmail
''';

      String phone = UserInfoConfig.phone.replaceAll(RegExp(r'[^\d+]'), '');
      if (!phone.startsWith('+')) {
        phone = '+1$phone'; // fallback to US code
      }

      final whatsappUrl = Uri.parse(
        'https://wa.me/$phone?text=${Uri.encodeComponent(whatsappMessage)}',
      );

      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        return true;
      } else {
        if (context != null && context.mounted) {
          _showErrorSnackbar(context, 'WhatsApp not available.');
        }
        return false;
      }
    } catch (e) {
      if (context != null && context.mounted) {
        _showErrorSnackbar(
          context,
          'Error sending WhatsApp message: ${e.toString()}',
        );
      }
      return false;
    }
  }

  /// ✅ Fallback: Copy contact message to clipboard
  static Future<void> copyToClipboard({
    required String name,
    required String senderEmail,
    required String message,
    String? serviceType,
    BuildContext? context,
  }) async {
    final formatted = formatContactDetailsForClipboard(
      name: name,
      senderEmail: senderEmail,
      message: message,
      serviceType: serviceType,
    );

    await Clipboard.setData(ClipboardData(text: formatted));

    if (context != null && context.mounted) {
      showSuccessSnackbar(context, 'Contact info copied to clipboard.');
    }
  }

  /// 🔤 Format message for clipboard fallback
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

Sent at: ${DateTime.now()}
''';
  }

  /// ❌ Show error snackbar
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

  /// ✅ Show success snackbar
  static void showSuccessSnackbar(BuildContext context, String message) {
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
}
