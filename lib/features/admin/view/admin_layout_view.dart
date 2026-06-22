import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/admin/controller/admin_controller.dart';
import 'package:staff_managememt_system/features/hr/widgets/hr_header.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../widgets/admin_header.dart';
import '../widgets/admin_sidebar.dart';
import 'access_control_view.dart';
import 'admin_settings_view.dart';
import 'audit_log_view.dart';
import 'command_center_view.dart';
import 'employee_management_view.dart';
import 'hr_management_view.dart';

class AdminLayoutView extends StatelessWidget {
  AdminLayoutView({super.key});

  final controller = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthController>().currentUser.value;

    if (user == null) {
      Future.microtask(() => Get.offAllNamed(AppRoutes.login));
      return const SizedBox();
    }

    if (user.role != 'Admin') {
      Future.microtask(() => Get.offAllNamed(AppRoutes.login));
      return const SizedBox();
    }
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(),

          Expanded(
            child: Column(
              children: [
                const AdminHeader(),

                Expanded(
                  child: Obx(
                    () => IndexedStack(
                      index: controller.selectedIndex.value,
                      children: const [CommandCenterView(), EmployeeManagementView(), HrManagementView(), AccessControlView(), AuditLogView(), AdminSettingsView()],
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
