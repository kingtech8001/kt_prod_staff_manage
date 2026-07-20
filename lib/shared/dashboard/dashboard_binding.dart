import 'package:get/get.dart';

import '../../core/controllers/auth_controller.dart';

import '../../features/admin/controller/admin_controller.dart';
import '../../features/admin/controller/hr_directory_controller.dart';

import '../../features/employee/controller/employee_controller.dart';

import '../../features/hr/controller/hr_controller.dart';
import '../../features/hr/controller/operations_controller.dart';

import '../employee_management_controller.dart';

class DashboardBinding {
  static String? _initializedRole;

  static void initialize(String? role) {
    if (role == null) return; // wait for real data, don't guess
    if (_initializedRole == role) return; // already correct, skip

    switch (role) {
      case 'Admin':
        _registerAdmin();
        break;
      case 'HR':
        _registerHr();
        break;
      default:
        _registerEmployee();
    }

    _initializedRole = role;
  }

  static void reset() {
    _initializedRole = null;
  }

  static void _registerEmployee() {
    if (!Get.isRegistered<EmployeeController>()) {
      Get.put(EmployeeController());
    }
  }

  static void _registerHr() {
    if (!Get.isRegistered<HrController>()) {
      Get.put(HrController());
    }

    if (!Get.isRegistered<OperationsController>()) {
      Get.put(OperationsController());
    }

    if (!Get.isRegistered<EmployeeManagementController>()) {
      Get.put(EmployeeManagementController());
    }
  }

  static void _registerAdmin() {
    if (!Get.isRegistered<AdminController>()) {
      Get.put(AdminController());
    }

    if (!Get.isRegistered<EmployeeManagementController>()) {
      Get.put(EmployeeManagementController());
    }

    if (!Get.isRegistered<HrDirectoryController>()) {
      Get.put(HrDirectoryController());
    }
  }
}
