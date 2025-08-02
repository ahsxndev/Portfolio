import 'package:flutter/material.dart';

class Responsive {

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 905;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 700 &&
      MediaQuery.of(context).size.width < 1100;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
}
