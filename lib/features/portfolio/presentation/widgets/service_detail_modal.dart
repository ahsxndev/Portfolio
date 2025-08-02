import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/responsive.dart';
import '../../../../core/config/user_info_config.dart';
import '../../../../core/services/email_service.dart';

class ServiceDetailModal extends StatefulWidget {
  final ServiceInfo service;
  final int serviceNumber;

  const ServiceDetailModal({
    super.key,
    required this.service,
    required this.serviceNumber,
  });

  @override
  State<ServiceDetailModal> createState() => _ServiceDetailModalState();
}

class _ServiceDetailModalState extends State<ServiceDetailModal>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeModal() {
    _animationController.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  Future<void> _handleGetStarted() async {
    final isMobile = MediaQuery.of(context).size.width < 600;

    // Show selection dialog for Email or WhatsApp
    final String? contactMethod = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Get Started with ${widget.service.title}',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ready to start your ${widget.service.title} project?',
              style: TextStyle(color: AppColors.white90),
            ),
            const SizedBox(height: 16),
            Text(
              'Choose how you\'d like to contact us:',
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
                    onPressed: () => Navigator.of(context).pop('email'),
                    icon: const Icon(Icons.email, size: 18),
                    label: const Text('Contact via Email'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getServiceColor(),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop('whatsapp'),
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
                    onPressed: () => Navigator.of(context).pop(null),
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
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.white70),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop('whatsapp'),
            icon: const Icon(Icons.message, size: 18),
            label: const Text('WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop('email'),
            icon: const Icon(Icons.email, size: 18),
            label: const Text('Email'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getServiceColor(),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (contactMethod != null && mounted) {
      // Close the modal first
      Navigator.of(context).pop();

      // Wait for modal to close
      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        final message = '''I'm interested in your ${widget.service.title} service.

Could we schedule a consultation to discuss:
- Project requirements and scope  
- Timeline and deliverables
- Pricing and next steps

Please let me know your availability.

Best regards''';

        bool success = false;

        if (contactMethod == 'email') {
          success = await EmailService.sendEmail(
            name: '[Your Name]',
            senderEmail: '[Your Email]',
            message: message,
            serviceType: widget.service.title,
            context: context,
          );

          if (success && mounted) {
            EmailService.showSuccessSnackbar(
              context,
              'Email client opened! Please fill in your contact details.',
            );
          }
        } else if (contactMethod == 'whatsapp') {
          success = await EmailService.sendWhatsAppMessage(
            name: '[Your Name]',
            senderEmail: '[Your Email]',
            message: message,
            serviceType: widget.service.title,
            context: context,
          );

          if (success && mounted) {
            EmailService.showSuccessSnackbar(
              context,
              'WhatsApp opened! Please update your details in the message.',
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: AppColors.black50,
            child: GestureDetector(
              onTap: _closeModal, // Direct backdrop tap to close
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent closing when tapping on modal content
                  behavior: HitTestBehavior.opaque,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      margin: EdgeInsets.all(isMobile ? 20 : 40),
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? double.infinity : 600,
                        maxHeight: MediaQuery.of(context).size.height * 0.85,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.white20, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black70,
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Container(
                            padding: EdgeInsets.all(isMobile ? 20 : 24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getServiceColor(),
                                  AppColors.withCustomOpacity(
                                    _getServiceColor(),
                                    0.8,
                                  ),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Service Number Badge
                                Container(
                                  width: isMobile ? 40 : 48,
                                  height: isMobile ? 40 : 48,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black30,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${widget.serviceNumber}',
                                      style: GoogleFonts.poppins(
                                        fontSize: isMobile ? 18 : 20,
                                        fontWeight: FontWeight.bold,
                                        color: _getServiceColor(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Title
                                Expanded(
                                  child: Text(
                                    widget.service.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: isMobile ? 22 : 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                // Close Button
                                IconButton(
                                  onPressed: _closeModal,
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  tooltip: 'Close',
                                  splashRadius: 24,
                                ),
                              ],
                            ),
                          ),

                          // Content
                          Flexible(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(isMobile ? 20 : 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Description
                                  Text(
                                    'Overview',
                                    style: GoogleFonts.poppins(
                                      fontSize: isMobile ? 18 : 20,
                                      fontWeight: FontWeight.w600,
                                      color: _getServiceColor(),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.service.description,
                                    style: GoogleFonts.poppins(
                                      fontSize: isMobile ? 14 : 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white90,
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Detailed Features
                                  Text(
                                    'What\'s Included',
                                    style: GoogleFonts.poppins(
                                      fontSize: isMobile ? 18 : 20,
                                      fontWeight: FontWeight.w600,
                                      color: _getServiceColor(),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ..._getServiceFeatures().map(
                                        (feature) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 6,
                                            ),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: _getServiceColor(),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              feature,
                                              style: GoogleFonts.poppins(
                                                fontSize: isMobile ? 14 : 16,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.white80,
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  // Technologies/Tools
                                  Text(
                                    'Technologies & Tools',
                                    style: GoogleFonts.poppins(
                                      fontSize: isMobile ? 18 : 20,
                                      fontWeight: FontWeight.w600,
                                      color: _getServiceColor(),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      ..._getServiceTechnologies().map(
                                            (tech) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.withCustomOpacity(
                                              _getServiceColor(),
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color:
                                              AppColors.withCustomOpacity(
                                                _getServiceColor(),
                                                0.5,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            tech,
                                            style: GoogleFonts.poppins(
                                              fontSize: isMobile ? 12 : 14,
                                              fontWeight: FontWeight.w500,
                                              color: _getServiceColor(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Action Button
                          Padding(
                            padding: EdgeInsets.all(isMobile ? 20 : 24),
                            child: GestureDetector(
                              onTap: _handleGetStarted,
                              child: Container(
                                width: double.infinity,
                                height: isMobile ? 48 : 52,
                                decoration: BoxDecoration(
                                  color: _getServiceColor(),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black20,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Get Started',
                                        style: GoogleFonts.poppins(
                                          fontSize: isMobile ? 16 : 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getServiceColor() {
    switch (widget.serviceNumber) {
      case 1:
        return AppColors.kBlue;
      case 2:
        return AppColors.kGreen;
      case 3:
        return AppColors.kPurple;
      case 4:
        return AppColors.kOrange;
      case 5:
        return AppColors.kTeal;
      default:
        return AppColors.kYellow;
    }
  }

  List<String> _getServiceFeatures() {
    return widget.service.features;
  }

  List<String> _getServiceTechnologies() {
    return widget.service.technologies;
  }
}