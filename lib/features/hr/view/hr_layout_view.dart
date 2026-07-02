import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/hr/widgets/hr_header.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/employee_management_controller.dart';
import '../../employee/view/dashboard_screens/activities_view.dart';
import '../../employee/view/dashboard_screens/announcements_view.dart';
import '../controller/hr_controller.dart';
import '../widgets/hr_sidebar.dart';
import 'employee directory/employee_profile_view.dart';
import 'hr_dashboard_view.dart';
import 'operational center/operations_center_view.dart';
import 'employee directory/employee_directory_view.dart';
import 'settings/settings_view.dart';

class HrLayoutView extends StatelessWidget {
  HrLayoutView({super.key});
  final employeeManagementController = Get.put(EmployeeManagementController());
  final hrController = Get.put(HrController());

  @override
  Widget build(BuildContext context) {
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
                        index: hrController.selectedIndex.value,
                        children: [
                          HrDashboardView(),
                          OperationsCenterView(),
                          EmployeeDirectoryView(),
                          SettingsView(),
                          AnnouncementsView(
                            onBack: () {
                              hrController.changeIndex(0);
                            },
                          ),
                          ActivitiesView(
                            onBack: () {
                              hrController.changeIndex(HrController.dashboard);
                            },
                          ),
                          /*LeaveApprovalView()*/
                        ],
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
