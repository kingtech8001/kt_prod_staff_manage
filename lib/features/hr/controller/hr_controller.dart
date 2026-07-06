import 'package:get/get.dart';

import '../../../shared/employee_management_controller.dart';
import 'employee_profile_controller.dart';

class HrController extends GetxController {
  final selectedIndex = 0.obs;
  final pageTitle = 'HR Operations Center'.obs;
  final pageSubtitle = ''.obs;
  final employeeManagement = Get.put(EmployeeManagementController());
  static const dashboard = 0;
  static const operations = 1;
  static const employeeDirectory = 2;
  static const settings = 3;
  static const announcements = 4;
  static const activities = 5;
  static const pendingRequests = 6;
  static const liveActivities = 7;
  static const employeeActivities = 8;

  @override
  void onInit() {
    super.onInit();

    changeIndex(0);
  }

  void updateHeader({required String title, String subtitle = ''}) {
    pageTitle.value = title;
    pageSubtitle.value = subtitle;
  }

  void changeIndex(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        updateHeader(
          title: 'HR Operations Center',
          subtitle: 'Manage workforce operations',
        );
        break;
      case 1:
        updateHeader(title: 'Dashboard', subtitle: ' ');
        break;

      case 2:
        updateHeader(
          title: 'Employee Directory',
          subtitle: 'Manage and monitor all employees',
        );
        break;

      /*case 2:
        updateHeader(title: 'Leave Approval', subtitle: 'Review employee leave requests');
        break;*/

      case 3:
        updateHeader(title: 'Settings', subtitle: 'System configuration');
        break;

      case 4:
        updateHeader(
          title: 'Company Announcements',
          subtitle: 'Latest company updates',
        );
        break;

      case activities:
        updateHeader(
          title: 'Recent Activities',
          subtitle: 'Latest employee activities',
        );
        break;

      case pendingRequests:
        updateHeader(
          title: 'Pending Leave Requests',
          subtitle: 'Review employee leave requests',
        );
        break;

      case liveActivities:
        updateHeader(
          title: 'Live Activity Feed',
          subtitle: 'Monitor employee activities',
        );
        break;

      case employeeActivities:
        updateHeader(
          title: 'Employee Activities',
          subtitle: 'Activity history',
        );
        break;
    }
  }
}
