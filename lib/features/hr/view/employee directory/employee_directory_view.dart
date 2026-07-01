import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/hr/widgets/employee_directory/quick_actions_card.dart';
import '../../../../shared/employee_management_controller.dart';
import '../../controller/employee_directory_controller.dart';
import '../../widgets/employee_directory/employee_filters.dart';
import '../../widgets/employee_directory/employee_list_card.dart';
import '../../widgets/employee_directory/employee_stats_row.dart';
import '../../widgets/employee_directory/live_activity_feed.dart';

class EmployeeDirectoryView extends StatelessWidget {
  // final controller = Get.put(EmployeeDirectoryController());
  final controller = Get.find<EmployeeManagementController>();

  EmployeeDirectoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Employees',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 20),

          const EmployeeStatsRow(),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    /*EmployeeFilters(),*/
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Employee List',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const SizedBox(height: 24),
                    const EmployeeListCard(),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    const QuickActionsCard(),
                    const SizedBox(height: 20),
                    LiveActivityFeed(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
