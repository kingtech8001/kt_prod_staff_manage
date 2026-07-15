import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/snackbar.dart';
import '../../admin/controller/hr_directory_controller.dart';
import '../repository/hr_repository.dart';
import 'employee_directory_controller.dart';

class AddEmployeeController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final designationController = TextEditingController();
  final repository = HrRepository();

  final isLoading = false.obs;

  final obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    designationController.dispose();

    super.onClose();
  }

  Future<void> createEmployee(String role) async {
    if (fullNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.trim().isEmpty ||
        designationController.text.trim().isEmpty) {
      CommonSnackbar.warning("Missing Information", "Please fill all fields.");
      return;
    }

    try {
      isLoading.value = true;

      await repository.createUser(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
        designation: designationController.text.trim(),
        role: role,
      );

      Get.back();

      CommonSnackbar.success("Success", "$role created successfully.");

      if (role == "Employee") {
        Get.find<EmployeeDirectoryController>().resetEmployees();
      } else {
        Get.find<HrDirectoryController>().resetHr();
      }
    } catch (e) {
      CommonSnackbar.error(
        "Failed",
        e.toString().replaceFirst("Exception: ", ""),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
