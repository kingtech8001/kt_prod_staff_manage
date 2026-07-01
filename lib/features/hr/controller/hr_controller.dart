import 'package:get/get.dart';

import '../../../shared/employee_management_controller.dart';
import 'employee_profile_controller.dart';

class HrController extends GetxController {
  final selectedIndex = 0.obs;
  final pageTitle = 'HR Operations Center'.obs;
  final pageSubtitle = ''.obs;
  final employeeManagement = Get.put(EmployeeManagementController());

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
    }
  }
}
