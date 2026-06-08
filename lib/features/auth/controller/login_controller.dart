import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/models/user_model.dart';
import '../../../core/routes/app_routes.dart';

class LoginController extends GetxController {
  final selectedRole = 'Employee'.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    emailController.text = "admin@proworkforce.com";
    passwordController.text = "Admin@123";
  }

  void changeRole(String role) {
    selectedRole.value = role;
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
        Get.snackbar('Error', 'Login Failed');
        return;
      }

      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      /*
      if (profile['role'] != selectedRole.value) {
        Get.snackbar(
          'Access Denied',
          'Selected role does not match account role',
        );

        await Supabase.instance.client.auth.signOut();
        return;
      }
*/

      final userModel = UserModel.fromJson(profile);

      Get.find<AuthController>().setUser(userModel);

      Get.offAllNamed(AppRoutes.employee);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
