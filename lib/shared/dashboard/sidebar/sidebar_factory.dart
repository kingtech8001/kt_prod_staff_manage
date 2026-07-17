import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/user_model.dart';
import '../../../core/models/user_role.dart';
import '../../../shared/employee_management_controller.dart';
import '../../../features/admin/controller/admin_controller.dart';
import '../../../features/employee/controller/employee_controller.dart';
import '../../../features/hr/controller/hr_controller.dart';

import 'sidebar_config.dart';
import 'sidebar_item.dart';

class SidebarFactory {
  static SidebarConfig getConfig(UserRole role) {
    switch (role) {
      case UserRole.employee:
        final controller = Get.find<EmployeeController>();

        return SidebarConfig(
          width: 260,

          selectedIndex: () => controller.selectedIndex.value,

          onItemSelected: controller.changeIndex,

          items: const [
            SidebarItem(title: 'Dashboard', icon: Icons.dashboard_outlined),
            SidebarItem(title: 'Attendance', icon: Icons.access_time),
            SidebarItem(
              title: 'Leave Requests',
              icon: Icons.event_note_outlined,
            ),
            SidebarItem(title: 'Performance', icon: Icons.bar_chart),
            SidebarItem(
              title: 'Company Policy',
              icon: Icons.description_outlined,
            ),
          ],
        );

      case UserRole.hr:
        final controller = Get.find<HrController>();
        final management = Get.find<EmployeeManagementController>();

        return SidebarConfig(
          width: 300,

          selectedIndex: () => controller.selectedIndex.value,

          onItemSelected: (index) {
            management.resetNavigationState();
            controller.changeIndex(index);
          },

          items: const [
            SidebarItem(title: 'Dashboard', icon: Icons.dashboard_outlined),
            SidebarItem(
              title: 'Operations Center',
              icon: Icons.business_center_outlined,
            ),
            SidebarItem(
              title: 'Employee Directory',
              icon: Icons.people_outline,
            ),
            SidebarItem(title: 'Settings', icon: Icons.settings_outlined),
          ],
        );

      case UserRole.admin:
        final controller = Get.find<AdminController>();
        final management = Get.find<EmployeeManagementController>();

        return SidebarConfig(
          width: 300,

          selectedIndex: () => controller.selectedIndex.value,

          onItemSelected: (index) {
            management.resetNavigationState();
            controller.changeIndex(index);
          },

          items: const [
            SidebarItem(
              title: 'Command Center',
              icon: Icons.dashboard_outlined,
            ),
            SidebarItem(
              title: 'Employee Management',
              icon: Icons.people_outline,
            ),
            SidebarItem(title: 'HR Management', icon: Icons.badge_outlined),
            SidebarItem(
              title: 'Access Control',
              icon: Icons.admin_panel_settings_outlined,
            ),
            SidebarItem(title: 'Audit Logs', icon: Icons.receipt_long_outlined),
            SidebarItem(title: 'Settings', icon: Icons.settings_outlined),
          ],
        );
    }
  }
}
