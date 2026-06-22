import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }

  Future<void> checkLogin() async {
    final authService = AuthService();

    if (!authService.isLoggedIn) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    final profile = await authService.getCurrentProfile();

    if (profile == null) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    final userModel = UserModel.fromJson(profile);

    Get.find<AuthController>().setUser(userModel);

    switch (userModel.role) {
      case 'Employee':
        Get.offAllNamed(AppRoutes.employee);
        break;

      case 'HR':
        Get.offAllNamed(AppRoutes.hr);
        break;

      case 'Admin':
        Get.offAllNamed(AppRoutes.admin);
        break;

      default:
        Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
