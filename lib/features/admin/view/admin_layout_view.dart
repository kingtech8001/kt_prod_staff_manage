import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/admin/controller/admin_controller.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/employee_management_controller.dart';
import '../../hr/view/employee directory/employee_directory_view.dart';
import '../../hr/view/employee directory/employee_profile_view.dart';
import '../widgets/admin_header.dart';
import '../widgets/admin_sidebar.dart';
import 'access_control_view.dart';
import 'admin_settings_view.dart';
import 'audit_log_view.dart';
import 'command_center_view.dart';
import 'hr_management_view.dart';

class AdminLayoutView extends StatelessWidget {
  AdminLayoutView({super.key});

  final controller = Get.put(AdminController());
  final employeeManagementController = Get.put(EmployeeManagementController());

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
            child: Obx(() {
              return Column(
                children: [
                  if (!employeeManagementController.isProfileOpen.value)
                    const AdminHeader(),

                  Expanded(
                    child: employeeManagementController.isProfileOpen.value
                        ? const EmployeeProfileView()
                        : IndexedStack(
                            index: controller.selectedIndex.value,
                            children: [
                              const CommandCenterView(),
                              EmployeeDirectoryView(),
                              const HrManagementView(),
                              const AccessControlView(),
                              const AuditLogView(),
                              const AdminSettingsView(),
                            ],
                          ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
