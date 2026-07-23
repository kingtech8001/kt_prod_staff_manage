import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/dashboard/role_content.dart';
import '../../../shared/employee_management_controller.dart';

import '../controller/admin_controller.dart';

import '../../hr/view/employee directory/employee_activities_view.dart';
import '../../hr/view/employee directory/employee_directory_view.dart';
import '../../hr/view/employee directory/employee_profile_view.dart';

import 'access_control_view.dart';
import 'admin_dashboard_view.dart';
import 'admin_settings_view.dart';
import 'audit_log_view.dart';
import 'command_center_view.dart';
import 'employee_activity_list_view.dart';
import 'hr_management_view.dart';

class AdminContent extends StatelessWidget {
  const AdminContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    final management = Get.find<EmployeeManagementController>();

    return Obx(() {
      if (management.isAdminActivityOpen.value) {
        return EmployeeActivityListView(onBack: management.closeAdminActivity);
      }
      return RoleContent(
        profileOpen: management.isProfileOpen.value,
        activityOpen: management.isActivityOpen.value,

        profileView: const EmployeeProfileView(),

        activityView: EmployeeActivitiesView(onBack: management.backToProfile),

        indexedContent: IndexedStack(
          index: controller.selectedIndex.value,
          children: [
            AdminDashboardView(),
            const CommandCenterView(),
            EmployeeDirectoryView(),
            const HrManagementView(),
            const AccessControlView(),
            const AuditLogView(),
            const AdminSettingsView(),
          ],
        ),
      );
    });
  }
}
