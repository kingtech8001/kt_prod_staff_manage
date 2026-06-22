import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/hr/widgets/hr_header.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../controller/employee_profile_controller.dart';
import '../controller/hr_controller.dart';
import '../widgets/hr_sidebar.dart';
import 'employee directory/employee_profile_view.dart';
import 'operational center/operations_center_view.dart';
import 'employee directory/employee_directory_view.dart';
import 'leave/leave_approval_view.dart';
import 'settings/settings_view.dart';

class HrLayoutView extends StatelessWidget {
  HrLayoutView({super.key});

  final controller = Get.put(HrController());
  final profileController = Get.put(EmployeeProfileController());

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthController>().currentUser.value;

    if (user == null) {
      Future.microtask(() => Get.offAllNamed(AppRoutes.login));
      return const SizedBox();
    }

    if (user.role != 'HR') {
      Future.microtask(() => Get.offAllNamed(AppRoutes.login));
      return const SizedBox();
    }
    return Scaffold(
      body: Row(
        children: [
          HrSidebar(),

          Expanded(
            child: Obx(
              () => Column(
                children: [
                  if (!controller.isProfileOpen.value) const HrHeader(),
                  Expanded(
                    child: Obx(() {
                      if (controller.isProfileOpen.value) {
                        return const EmployeeProfileView();
                      }

                      return IndexedStack(
                        index: controller.selectedIndex.value,
                        children: [OperationsCenterView(), EmployeeDirectoryView(), /*LeaveApprovalView()*/ SettingsView()],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
