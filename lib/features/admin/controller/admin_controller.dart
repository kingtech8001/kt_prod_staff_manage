import 'package:get/get.dart';

class AdminController extends GetxController {
  static const int dashboard = 0;
  static const int commandCenter = 1;
  static const int employeeManagement = 2;
  static const int hrManagement = 3;
  static const int accessControl = 4;
  static const int auditLogs = 5;
  static const int settings = 6;

  final selectedIndex = dashboard.obs;

  final pageTitle = 'Dashboard'.obs;
  final pageSubtitle = 'Global Workforce Overview'.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;

    switch (index) {
      case dashboard:
        pageTitle.value = 'Dashboard';
        pageSubtitle.value = 'Global Workforce Overview';
        break;

      case commandCenter:
        pageTitle.value = 'Command Center';
        pageSubtitle.value = 'Global Workforce Overview';
        break;

      case employeeManagement:
        pageTitle.value = 'Employee Management';
        pageSubtitle.value = 'Manage employee accounts';
        break;

      case hrManagement:
        pageTitle.value = 'HR Management';
        pageSubtitle.value = 'Manage HR accounts';
        break;

      case accessControl:
        pageTitle.value = 'Access Control';
        pageSubtitle.value = 'Roles and permissions';
        break;

      case auditLogs:
        pageTitle.value = 'Audit Logs';
        pageSubtitle.value = 'System activity history';
        break;

      case settings:
        pageTitle.value = 'Settings';
        pageSubtitle.value = 'System configuration';
        break;
    }
  }
}
