import 'package:get/get.dart';

import '../features/hr/controller/employee_directory_controller.dart';
import '../features/hr/controller/employee_profile_controller.dart';
import '../features/hr/controller/hr_controller.dart';

class EmployeeManagementController extends GetxController {
  final directoryController = Get.put(EmployeeDirectoryController());
  final profileController = Get.put(EmployeeProfileController());
  final selectedEmployee = Rxn<Map>();
  final selectedTab = 'Overview'.obs;
  final isAdminActivityOpen = false.obs;

  final previousIndex = 0.obs;

  final isProfileOpen = false.obs;
  final isActivityOpen = false.obs;

  bool get shouldShowHeader => !isProfileOpen.value && !isActivityOpen.value;

  @override
  void onInit() {
    super.onInit();
    print("EmployeeManagementController initialized");
  }

  Future<void> openEmployeeProfile(
    Map<String, dynamic> employee, {
    String role = 'Employee',
  }) async {
    selectedEmployee.value = employee;

    profileController.setProfileRole(role);

    isProfileOpen.value = true;

    await profileController.loadEmployee(employee['id']);
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
  }

  void backToDirectory() {
    isActivityOpen.value = false;
    isProfileOpen.value = false;
    selectedEmployee.value = null;
  }

  void openActivities() {
    isProfileOpen.value = false;
    isActivityOpen.value = true;
  }

  void backToProfile() {
    isActivityOpen.value = false;
    isProfileOpen.value = true;
  }

  void resetNavigationState() {
    isProfileOpen.value = false;
    isActivityOpen.value = false;
    selectedEmployee.value = null;
  }

  void openAdminActivity() {
    isAdminActivityOpen.value = true;
  }

  void closeAdminActivity() {
    isAdminActivityOpen.value = false;
  }
}
