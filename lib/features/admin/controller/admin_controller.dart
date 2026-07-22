import 'package:get/get.dart';

class AdminController extends GetxController {
  final selectedIndex = 0.obs;

  final pageTitle = 'Command Center'.obs;
  final pageSubtitle = 'Global Workforce Overview'.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;

    switch (index) {
      case 0:
        pageTitle.value = 'Dashboard';
        pageSubtitle.value = 'Global Workforce Overview';
        break;

      case 1:
        pageTitle.value = 'Command Center';
        pageSubtitle.value = 'Global Workforce Overview';
        break;

      case 2:
        pageTitle.value = 'Employee Management';
        pageSubtitle.value = 'Manage employee accounts';
        break;

      case 3:
        pageTitle.value = 'HR Management';
        pageSubtitle.value = 'Manage HR accounts';
        break;

      case 4:
        pageTitle.value = 'Access Control';
        pageSubtitle.value = 'Roles and permissions';
        break;

      case 5:
        pageTitle.value = 'Audit Logs';
        pageSubtitle.value = 'System activity history';
        break;

      case 6:
        pageTitle.value = 'Settings';
        pageSubtitle.value = 'System configuration';
        break;
    }
  }
}
