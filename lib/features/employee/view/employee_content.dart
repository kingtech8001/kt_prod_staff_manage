import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/employee_controller.dart';

import 'attendance_view.dart';
import 'dashboard_screens/activities_view.dart';
import 'dashboard_screens/announcements_view.dart';
import 'dashboard_screens/dashboard_view.dart';
import 'leave_view.dart';
import 'performance_view.dart';
import 'policy_view.dart';

class EmployeeContent extends StatelessWidget {
  const EmployeeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeController>();

    return Obx(
      () => IndexedStack(
        index: controller.selectedIndex.value,
        children: [
          const DashboardView(),
          AttendanceView(),
          LeaveView(),
          PerformanceView(),
          const PolicyView(),
          AnnouncementsView(
            onBack: () {
              controller.changeIndex(EmployeeController.dashboard);
            },
          ),
          ActivitiesView(
            onBack: () {
              controller.changeIndex(EmployeeController.dashboard);
            },
          ),
        ],
      ),
    );
  }
}
