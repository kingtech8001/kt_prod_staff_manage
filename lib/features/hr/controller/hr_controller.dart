import 'package:get/get.dart';

import 'employee_profile_controller.dart';

class HrController extends GetxController {
  final selectedIndex = 0.obs;
  final selectedTab = 'Overview'.obs;
  final pageTitle = 'HR Operations Center'.obs;
  final pageSubtitle = ''.obs;
  final selectedEmployee = Rxn<Map>();
  final isProfileOpen = false.obs;

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
        updateHeader(title: 'HR Operations Center', subtitle: 'Manage workforce operations');
        break;

      case 1:
        updateHeader(title: 'Employee Directory', subtitle: 'Manage and monitor all employees');
        break;

      /*case 2:
        updateHeader(title: 'Leave Approval', subtitle: 'Review employee leave requests');
        break;*/

      case 2:
        updateHeader(title: 'Settings', subtitle: 'System configuration');
        break;
    }
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  void openEmployeeProfile(Map employee) {
    selectedEmployee.value = employee;
    isProfileOpen.value = true;

    final profileController = Get.find<EmployeeProfileController>();

    profileController.loadEmployee(employee['id']);
  }

  void backToDirectory() {
    isProfileOpen.value = false;
  }
}
