import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/employee/view/performance_view.dart';
import 'package:staff_managememt_system/features/employee/view/policy_view.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../controller/employee_controller.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/employee_sidebar.dart';
import 'attendance_view.dart';
import 'dashboard_view.dart';
import 'leave_view.dart';

class EmployeeLayoutView extends StatelessWidget {
  EmployeeLayoutView({super.key});

  final controller = Get.put(EmployeeController());
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final user = authController.currentUser.value;

    if (user == null) {
      Future.microtask(() => Get.offAllNamed(AppRoutes.login));
      return const SizedBox();
    }

    if (user.role != 'Employee') {
      Future.microtask(() => Get.offAllNamed(AppRoutes.login));
      return const SizedBox();
    }
    return Scaffold(
      body: Row(
        children: [
          EmployeeSidebar(),

          Expanded(
            child: Column(
              children: [
                const DashboardHeader(),

                Expanded(
                  child: Obx(
                    () => IndexedStack(
                      index: controller.selectedIndex.value,
                      children: [const DashboardView(), AttendanceView(), LeaveView(), PerformanceView(), const PolicyView()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
