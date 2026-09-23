import 'package:flutter/material.dart';
import 'package:tailorx/core/theme/app_theme.dart';
import 'package:tailorx/core/theme/theme_controller.dart';
import 'package:tailorx/features/auth/presentation/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TailorXApp());
}

class TailorXApp extends StatelessWidget {
  const TailorXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (
          BuildContext context,
          Widget? child,
          ) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TailorX',

          /// Light mode design
          theme: AppTheme.lightTheme,

          /// Dark mode design
          darkTheme: AppTheme.darkTheme,

          /// Controlled globally by ThemeController
          themeMode: ThemeController.instance.themeMode,

          home: const LoginScreen(),
        );
      },
    );
  }
}
