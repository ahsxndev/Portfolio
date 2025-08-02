import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfolio/core/constants/app_colors.dart';
import 'package:myfolio/core/constants/responsive.dart';
import 'package:myfolio/core/config/user_info_config.dart';

class AvatarWidget extends StatelessWidget {
  final bool fromDrawer;
  const AvatarWidget({this.fromDrawer = false, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    final double outerSize = isMobile || fromDrawer ? 48 : 60;
    final double innerSize = isMobile || fromDrawer ? 48 : 60;
    final double fontSize = isMobile || fromDrawer ? 24 : 32;
    final double offset = isMobile || fromDrawer ? -4 : -5;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: offset,
            bottom: offset,
            child: Container(
              width: outerSize,
              height: outerSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
            ),
          ),
          Container(
            width: innerSize,
            height: innerSize,
            decoration: BoxDecoration(
              color: AppColors.kYellow,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: Text(
                UserInfoConfig.firstName.isNotEmpty
                    ? UserInfoConfig.firstName[0].toUpperCase()
                    : 'U',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w800,
                  fontSize: fontSize,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}