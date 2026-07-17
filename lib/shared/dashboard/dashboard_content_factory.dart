import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/auth_controller.dart';

import '../../features/admin/view/admin_content.dart';
import '../../features/employee/view/employee_content.dart';
import '../../features/hr/view/hr_content.dart';

class DashboardContentFactory {
  static Widget build(AuthController authController) {
    switch (authController.currentUser.value?.role) {
      case 'Admin':
        return const AdminContent();

      case 'HR':
        return const HrContent();

      default:
        return const EmployeeContent();
    }
  }
}
