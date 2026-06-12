import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/hr/widgets/employee_directory/quick_actions_card.dart';
import '../../controller/employee_directory_controller.dart';
import '../../widgets/employee_directory/employee_filters.dart';
import '../../widgets/employee_directory/employee_row.dart';
import '../../widgets/employee_directory/employee_stats_row.dart';

final controller = Get.put(EmployeeDirectoryController());

class EmployeeDirectoryView extends StatelessWidget {
  const EmployeeDirectoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Employee Directory', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),

          const SizedBox(height: 6),

          const Text('Manage and monitor all employees', style: TextStyle(color: Color(0xFF64748B))),

          const SizedBox(height: 24),

          const EmployeeStatsRow(),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 3, child: Column(children: [EmployeeFilters(), SizedBox(height: 24), EmployeeListCard()])),

              const SizedBox(width: 24),

              const Expanded(flex: 1, child: QuickActionsCard()),
            ],
          ),
        ],
      ),
    );
  }
}
