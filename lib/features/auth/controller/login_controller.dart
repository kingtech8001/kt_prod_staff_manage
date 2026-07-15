import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/models/user_model.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/snackbar.dart';

class LoginController extends GetxController {
  final selectedRole = 'Employee'.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fillCredentials(selectedRole.value);
  }

  void changeRole(String role) {
    selectedRole.value = role;
    _fillCredentials(role);
  }

  Future<void> login() async {
    try {
      isLoading.value = true;

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        CommonSnackbar.error('Login Failed', 'Invalid email or password');
        return;
      }

      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      if (profile['role'] != selectedRole.value) {
        await Supabase.instance.client.auth.signOut();

        CommonSnackbar.error(
          'Invalid Credentials',
          'Selected role does not match account type',
        );

        return;
      }

      final userModel = UserModel.fromJson(profile);

      Get.find<AuthController>().setUser(userModel);

      switch (selectedRole.value) {
        case 'Employee':
          Get.offAllNamed(AppRoutes.employee);
          break;

        case 'HR':
          Get.offAllNamed(AppRoutes.hr);
          break;

        case 'Admin':
          Get.offAllNamed(AppRoutes.admin);
          break;
      }
    } catch (e) {
      CommonSnackbar.error('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _fillCredentials(String role) {
    switch (role) {
      case 'Employee':
        emailController.text = 'employee@proworkforce.com';
        passwordController.text = 'Emp@123';
        break;

      case 'HR':
        emailController.text = 'hr@proworkforce.com';
        passwordController.text = 'HR@123';
        break;

      case 'Admin':
        emailController.text = 'admin@proworkforce.com';
        passwordController.text = 'Admin@123';
        break;
    }
  }
}
