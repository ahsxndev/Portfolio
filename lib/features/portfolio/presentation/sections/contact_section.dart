import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';

import '../widgets/contact_form.dart';
import '../widgets/contact_info_box.dart';
import '../widgets/custom_button.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  bool showForm = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double screenWidth = Responsive.screenWidth(context);
    final bool isSmallScreen = screenWidth < 500;

    final bool isResponseNeed = MediaQuery.of(context).size.width < 700;

    return Container(
      color: AppColors.kGreen,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: isMobile ? 16 : 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "If You have any Query or Project ideas feel free to  ",
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 20 : 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Show form OR button
          if (!showForm)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 350,
              ),
              child: CustomButton(
                text: 'Contact Me',
                width: isSmallScreen
                    ? 200
                    : isMobile
                    ? 250
                    : 350,
                isContact: true,
                tooltip: 'Send me a message or get in touch',
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: AppColors.kBlue,
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 100,
                        vertical: isMobile ? 24 : 24,
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                          maxWidth: isMobile ? double.infinity : 600,
                        ),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.kBlue,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0x1AFFFFFF),
                            width: 1,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Contact Form',
                                    style: GoogleFonts.montserrat(
                                      fontSize: isMobile ? 20 : 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white70,
                                    ),
                                    splashRadius: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              if (!isResponseNeed) ...[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Increase size of ContactInfoBox (left box)
                                    Flexible(
                                      flex: 5, // was 4
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          minWidth: 300,
                                          maxWidth: 400,
                                        ),
                                        child: ContactInfoBox(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ), // smaller spacing
                                    // Decrease width of ContactForm (right box)
                                    Flexible(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ), // ✅ Reduce right spacing
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 360,
                                          ), // ✅ Limit form width
                                          child: ContactForm(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                ContactInfoBox(),
                                const SizedBox(height: 24),
                                ContactForm(),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            isResponseNeed
                ? ContactForm()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: ContactInfoBox()),
                      const SizedBox(width: 40),
                      Expanded(child: ContactForm()),
                    ],
                  ),
        ],
      ),
    );
  }
}
