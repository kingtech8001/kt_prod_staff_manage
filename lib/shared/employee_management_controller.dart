import 'package:get/get.dart';

import '../features/hr/controller/employee_directory_controller.dart';
import '../features/hr/controller/employee_profile_controller.dart';

class EmployeeManagementController extends GetxController {
  final directoryController = Get.put(EmployeeDirectoryController());
  final profileController = Get.put(EmployeeProfileController());
  final selectedEmployee = Rxn<Map>();
  final selectedTab = 'Overview'.obs;

  final isProfileOpen = false.obs;

  Future<void> openEmployeeProfile(Map<String, dynamic> employee) async {
    print("Inside openEmployeeProfile");
    print(employee['full_name']);
    selectedEmployee.value = employee;

    isProfileOpen.value = true;
    print("is profile open value => ${isProfileOpen.value}");
    await profileController.loadEmployee(employee['id']);
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  void backToDirectory() {
    isProfileOpen.value = false;
  }
}
