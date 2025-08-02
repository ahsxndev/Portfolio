import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/services/email_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myfolio/core/config/user_info_config.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final messageCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x08000000),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Message',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: nameCtrl,
              label: 'Full Name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: emailCtrl,
              label: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: messageCtrl,
              label: 'Your Message',
              icon: Icons.message_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kYellow,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: const Color(0x99FFDD55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Sending...',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Send Message',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    const labelColor = Colors.white;
    const hintColor = Color(0x99FFFFFF);
    const fillColor = Color(0x1AFFFFFF);
    const borderColor = Color(0x33FFFFFF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.kYellow, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: labelColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
            if (label.contains('Email') &&
                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint ?? 'Enter $label',
            hintStyle: const TextStyle(color: hintColor, fontSize: 14),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.kYellow, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final name = nameCtrl.text.trim();
      final email = emailCtrl.text.trim();
      final message = messageCtrl.text.trim();

      final subject = 'Portfolio Contact Form Message';
      final body =
          '''
Hello ${UserInfoConfig.fullName},

You have received a new message:

Name: $name
Email: $email
Message: $message

=== AUTOMATED SIGNATURE ===
This message was sent through your portfolio contact form.
''';

      final Uri emailUri = Uri.parse(
        'mailto:${UserInfoConfig.email}'
        '?subject=${Uri.encodeComponent(subject)}'
        '&body=${Uri.encodeComponent(body)}',
      );

      final bool launched = await launchUrl(emailUri);

      if (!mounted) return;

      if (launched) {
        nameCtrl.clear();
        emailCtrl.clear();
        messageCtrl.clear();

        EmailService.showSuccessSnackbar(
          context,
          'Email client opened! Please send the message.',
        );

        await _showSendOptionsDialog(name, email, message);
      } else {
        await _showAlternativeOptionsDialog(name, email, message);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Error: ${e.toString()}')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  /// Show additional sending options after successful email launch
  Future<void> _showSendOptionsDialog(
    String name,
    String email,
    String message,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Message Ready!',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your email client should have opened with a pre-filled message.',
              style: TextStyle(color: AppColors.white90),
            ),
            const SizedBox(height: 16),
            Text(
              'Additional options:',
              style: TextStyle(
                color: AppColors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Done', style: TextStyle(color: AppColors.white70)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await EmailService.sendWhatsAppMessage(
                name: name,
                senderEmail: email,
                message: message,
                context: context,
              );
            },
            icon: const Icon(Icons.message, size: 18),
            label: const Text('WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final clipboardData =
                  EmailService.formatContactDetailsForClipboard(
                    name: name,
                    senderEmail: email,
                    message: message,
                  );
              await Clipboard.setData(ClipboardData(text: clipboardData));

              if (context.mounted) {
                Navigator.pop(context);
                EmailService.showSuccessSnackbar(
                  context,
                  'Contact details copied to clipboard!',
                );
              }
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copy'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kYellow,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// Show alternative options if email client failed
  Future<void> _showAlternativeOptionsDialog(
    String name,
    String email,
    String message,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Alternative Contact Methods',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No email client found. Please choose an alternative:',
              style: TextStyle(color: AppColors.white90),
            ),
            const SizedBox(height: 16),
            Text(
              'Your message is ready to be sent through:',
              style: TextStyle(
                color: AppColors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.white70)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await EmailService.sendWhatsAppMessage(
                name: name,
                senderEmail: email,
                message: message,
                context: context,
              );
            },
            icon: const Icon(Icons.message, size: 18),
            label: const Text('WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final clipboardData =
                  EmailService.formatContactDetailsForClipboard(
                    name: name,
                    senderEmail: email,
                    message: message,
                  );
              await Clipboard.setData(ClipboardData(text: clipboardData));

              if (context.mounted) {
                Navigator.pop(context);
                EmailService.showSuccessSnackbar(
                  context,
                  'Contact details copied! You can paste and send manually.',
                );
              }
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copy Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kYellow,
              foregroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
