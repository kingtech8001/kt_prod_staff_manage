import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/employee/widgets/dashboard/upcoming_holidays_card.dart';
import '../../../shared/dashboard/role_content.dart';
import '../../../shared/employee_management_controller.dart';
import '../controller/hr_controller.dart';
import '../../employee/view/dashboard_screens/activities_view.dart';
import '../../employee/view/dashboard_screens/announcements_view.dart';
import '../widgets/operation center/live_activity_card.dart';
import 'employee directory/employee_activities_view.dart';
import 'employee directory/employee_directory_view.dart';
import 'employee directory/employee_profile_view.dart';
import 'hr_dashboard_view.dart';
import 'operational center/operations_center_view.dart';
import 'operational center/pending_requests_view.dart';
import 'settings/settings_view.dart';

class HrContent extends StatelessWidget {
  const HrContent({super.key});

  @override
  Widget build(BuildContext context) {
    final hrController = Get.find<HrController>();
    final management = Get.find<EmployeeManagementController>();

    return Obx(
      () => RoleContent(
        profileOpen: management.isProfileOpen.value,
        activityOpen: management.isActivityOpen.value,

        profileView: const EmployeeProfileView(),

        activityView: EmployeeActivitiesView(onBack: management.backToProfile),

        indexedContent: IndexedStack(
          index: hrController.selectedIndex.value,
          children: [
            HrDashboardView(),

            OperationsCenterView(),

            EmployeeDirectoryView(),

            SettingsView(),

            AnnouncementsView(
              onBack: () {
                hrController.changeIndex(HrController.dashboard);
              },
            ),

            ActivitiesView(
              onBack: () {
                hrController.changeIndex(HrController.dashboard);
              },
            ),

            PendingRequestsView(
              onBack: () {
                hrController.changeIndex(HrController.operations);
              },
            ),

            LiveActivitiesView(
              onBack: () {
                hrController.changeIndex(HrController.operations);
              },
            ),

            EmployeeActivitiesView(
              onBack: () {
                hrController.changeIndex(management.previousIndex.value);

                management.isProfileOpen.value = true;
              },
            ),
            HolidaysView(
              onBack: () {
                hrController.changeIndex(HrController.dashboard);
              },
            ),
          ],
        ),
      ),
    );
  }
}
