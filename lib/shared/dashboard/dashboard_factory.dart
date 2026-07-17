import 'package:get/get.dart';
import 'package:staff_managememt_system/shared/dashboard/sidebar/dashboard_sidebar.dart';
import 'package:staff_managememt_system/shared/dashboard/sidebar/sidebar_factory.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/models/user_role.dart';
import '../../features/admin/widgets/admin_header.dart';
import '../../features/employee/widgets/dashboard/dashboard_header.dart';
import '../../features/hr/widgets/hr_header.dart';
import '../employee_management_controller.dart';
import 'dashboard_config.dart';
import 'dashboard_content_factory.dart';

class DashboardFactory {
  static DashboardConfig create(AuthController authController) {
    switch (authController.currentUser.value?.userRole) {
      case UserRole.admin:
        return DashboardConfig(
          sidebarBuilder: () => DashboardSidebar(
            config: SidebarFactory.getConfig(UserRole.admin),
          ),
          headerBuilder: () => const AdminHeader(),
          bodyBuilder: () => DashboardContentFactory.build(authController),
          showHeader: () =>
              Get.find<EmployeeManagementController>().shouldShowHeader,
        );

      case UserRole.hr:
        return DashboardConfig(
          sidebarBuilder: () =>
              DashboardSidebar(config: SidebarFactory.getConfig(UserRole.hr)),
          headerBuilder: () => HrHeader(),
          bodyBuilder: () => DashboardContentFactory.build(authController),
          showHeader: () =>
              Get.find<EmployeeManagementController>().shouldShowHeader,
        );

      default:
        return DashboardConfig(
          sidebarBuilder: () => DashboardSidebar(
            config: SidebarFactory.getConfig(UserRole.employee),
          ),
          headerBuilder: () => const DashboardHeader(),
          bodyBuilder: () => DashboardContentFactory.build(authController),
          showHeader: () => true,
        );
    }
  }
}
