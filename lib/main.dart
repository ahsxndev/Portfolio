import 'package:flutter/material.dart';
import 'package:myfolio/core/constants/app_colors.dart';

import 'features/portfolio/presentation/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ahsan',
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.kYellow,
          selectionColor: AppColors.yellow30,
          selectionHandleColor: AppColors.kYellow,
        ),
      ),
      home: MainScreen(),
    );
  }
}

