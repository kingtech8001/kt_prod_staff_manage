import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/employee_profile_controller.dart';
import 'attendance_action_dialog.dart';

class HrActionsCard extends StatelessWidget {
  const HrActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeProfileController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HR Actions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AttendanceActionDialog(title: 'Mark Present', onConfirm: controller.markPresent),
                );
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: Row(mainAxisAlignment: .center, children: [Icon(Icons.check), SizedBox(width: 5), const Text('Mark as Present')]),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AttendanceActionDialog(title: 'Mark Absent', onConfirm: controller.markAbsent),
                );
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: Row(mainAxisAlignment: .center, children: [Icon(Icons.close), SizedBox(width: 5), const Text('Mark as Absent')]),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AttendanceActionDialog(title: 'Mark Leave', onConfirm: controller.markLeave),
                );
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: Row(mainAxisAlignment: .center, children: [Icon(Icons.check), SizedBox(width: 5), const Text('Mark as Leave')]),
            ),
          ),
        ],
      ),
    );
  }
}
