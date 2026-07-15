import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/admin/controller/admin_controller.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/employee_management_controller.dart';
import '../../hr/view/employee directory/employee_activities_view.dart';
import '../../hr/view/employee directory/employee_directory_view.dart';
import '../../hr/view/employee directory/employee_profile_view.dart';
import '../controller/hr_directory_controller.dart';
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
  final hrDirectoryController = Get.put(HrDirectoryController());

  @override
  Widget build(BuildContext context) {
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
                        : employeeManagementController.isActivityOpen.value
                        ? EmployeeActivitiesView(
                            onBack: () =>
                                employeeManagementController.backToProfile(),
                          )
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
