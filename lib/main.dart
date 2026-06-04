import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/controllers/auth_controller.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://qgrxmyqjgmwqijzsemon.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFncnhteXFqZ213cWlqenNlbW9uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA0NjE1OTIsImV4cCI6MjA5NjAzNzU5Mn0.Ks6pevwSFGsW50cGB_usB7xBPRLKA3v-aUd_3pJa5bw',
  );

  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProWorkforce',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
