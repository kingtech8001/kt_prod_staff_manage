import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/auth/screens/login_view.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, title: 'ProWorkforce', theme: AppTheme.lightTheme, home: const LoginView());
  }
}
