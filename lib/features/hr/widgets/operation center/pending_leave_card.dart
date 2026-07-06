import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/view_all_button.dart';
import '../../controller/hr_controller.dart';
import '../../controller/operations_controller.dart';

class PendingLeaveCard extends StatelessWidget {
  const PendingLeaveCard({super.key});

  @override
  Widget build(BuildContext context) {
    final hrController = Get.find<HrController>();
    final controller = Get.put(OperationsController());
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pending Leave Requests',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Obx(() {
              if (controller.pendingLeaves.isEmpty) {
                return const Center(
                  child: Text(
                    'No pending leave requests',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                );
              }

              return ListView.separated(
                itemCount: controller.pendingLeaves.length,

                separatorBuilder: (_, __) => const Divider(),

                itemBuilder: (context, index) {
                  final leave = controller.pendingLeaves[index];
                  final profile = leave['profiles'];
                  final start = DateTime.parse(leave['start_date']);
                  final end = DateTime.parse(leave['end_date']);
                  final days = end.difference(start).inDays + 1;

                  return _leaveItem(
                    name: profile?['full_name'] ?? 'Employee',
                    type: leave['leave_type'] ?? '',
                    days: '$days Day${days > 1 ? 's' : ''}',
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 40,
            width: double.infinity,
            child: ViewAllButton(
              bgColor: false,
              text: 'Review All Requests',
              onPressed: () async {
                hrController.changeIndex(HrController.pendingRequests);
                await controller.resetPendingLeaves();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaveItem({
    required String name,
    required String type,
    required String days,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF64748b),
            foregroundColor: Colors.white,
            child: Text(name[0]),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),

                Text(
                  type,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(days, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
