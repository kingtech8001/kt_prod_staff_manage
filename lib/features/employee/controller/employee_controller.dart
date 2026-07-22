import 'package:get/get.dart';

class EmployeeController extends GetxController {
  final selectedIndex = 0.obs;

  static const dashboard = 0;
  static const attendance = 1;
  static const leave = 2;
  static const performance = 3;
  static const policies = 4;
  static const announcements = 5;
  static const activities = 6;
  static const holidays = 7;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
