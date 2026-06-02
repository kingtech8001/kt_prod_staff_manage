import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_textfield.dart';
import '../controller/login_controller.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome Back', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            const Text('Sign in to continue to ProWorkforce', style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 32),

            const Text('Role', style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 12),

            Obx(
              () => Row(
                children: [
                  Radio<String>(
                    activeColor: const Color(0xFF0B1633),
                    value: 'Employee',
                    groupValue: controller.selectedRole.value,
                    onChanged: (value) => controller.changeRole(value!),
                  ),
                  const Text('Employee'),

                  const SizedBox(width: 24),

                  Radio<String>(activeColor: const Color(0xFF0B1633), value: 'HR', groupValue: controller.selectedRole.value, onChanged: (value) => controller.changeRole(value!)),
                  const Text('HR'),

                  const SizedBox(width: 24),

                  Radio<String>(
                    activeColor: const Color(0xFF0B1633),
                    value: 'Admin',
                    groupValue: controller.selectedRole.value,
                    onChanged: (value) => controller.changeRole(value!),
                  ),
                  const Text('Admin'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const AppTextField(hint: 'Enter work email', prefixIcon: Icons.email_outlined),

            const SizedBox(height: 16),

            const AppTextField(hint: 'Enter password', prefixIcon: Icons.lock_outline, obscureText: true),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, child: const Text('Forgot Password?')),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B1633),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {},
                child: const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
