import 'package:get/get.dart';

import '../../core/controllers/auth_controller.dart';

import '../../features/admin/controller/admin_controller.dart';
import '../../features/admin/controller/hr_directory_controller.dart';

import '../../features/employee/controller/employee_controller.dart';

import '../../features/hr/controller/hr_controller.dart';
import '../../features/hr/controller/operations_controller.dart';

import '../employee_management_controller.dart';

class DashboardBinding {
  static bool _initialized = false;

  static void initialize() {
    if (!Get.isRegistered<EmployeeController>()) {
      Get.put(EmployeeController());
    }

    final auth = Get.find<AuthController>();

    switch (auth.currentUser.value?.role) {
      case 'Admin':
        _registerAdmin();
        break;

      case 'HR':
        _registerHr();
        break;

      default:
        _registerEmployee();
    }

    _initialized = true;
  }

  static void _registerEmployee() {
    Get.put(EmployeeController());
  }

  static void _registerHr() {
    Get.put(HrController());
    Get.put(OperationsController());
    Get.put(EmployeeManagementController());
  }

  static void _registerAdmin() {
    Get.put(AdminController());
    Get.put(EmployeeManagementController());
    Get.put(HrDirectoryController());
  }

  static void reset() {
    _initialized = false;
  }
}
