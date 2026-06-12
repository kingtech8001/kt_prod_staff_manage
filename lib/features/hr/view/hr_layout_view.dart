import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/hr/widgets/hr_header.dart';
import '../controller/hr_controller.dart';
import '../widgets/hr_sidebar.dart';
import 'operational center/operations_center_view.dart';
import 'employee directory/employee_directory_view.dart';
import 'leave/leave_approval_view.dart';
import 'performance/performance_view.dart';
import 'reports/reports_view.dart';
import 'settings/settings_view.dart';

class HrLayoutView extends StatelessWidget {
  HrLayoutView({super.key});

  final controller = Get.put(HrController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          HrSidebar(),

          Expanded(
            child: Column(
              children: [
                const HrHeader(),
                Expanded(
                  child: Obx(
                    () => IndexedStack(
                      index: controller.selectedIndex.value,
                      children: [
                        const OperationsCenterView(),
                        const EmployeeDirectoryView(),
                        const LeaveApprovalView(),
                        HrPerformanceView(),
                        const ReportsView(),
                        const SettingsView(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
