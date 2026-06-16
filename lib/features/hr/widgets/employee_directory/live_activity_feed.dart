import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../controller/employee_directory_controller.dart';

class LiveActivityFeed extends StatelessWidget {
  LiveActivityFeed({super.key});

  final controller = Get.find<EmployeeDirectoryController>();

  @override
  Widget build(BuildContext context) {
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
          const Text('Live Activity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

          const SizedBox(height: 20),

          Obx(() {
            if (controller.isLoadingActivities.value) {
              return const Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.liveActivities.isEmpty) {
              return const Padding(padding: EdgeInsets.all(20), child: Text('No live activity yet'));
            }

            return Column(children: controller.liveActivities.map((activity) => _activityItem(activity)).toList());
          }),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B1633),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('View All Activity'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityItem(Map<String, dynamic> activity) {
    final profile = activity['profiles'];

    final employeeName = profile?['full_name'] ?? 'Unknown Employee';

    final activityType = activity['activity_type']?.toString() ?? '';

    IconData icon;
    Color iconColor;

    switch (activityType) {
      case 'CHECK_IN':
        icon = Icons.login;
        iconColor = Colors.green;
        break;

      case 'CHECK_OUT':
        icon = Icons.logout;
        iconColor = Colors.red;
        break;

      case 'BREAK_START':
        icon = Icons.coffee;
        iconColor = Colors.orange;
        break;

      case 'BREAK_END':
        icon = Icons.work_outline;
        iconColor = Colors.blue;
        break;

      case 'LEAVE_REQUEST':
        icon = Icons.event_note_outlined;
        iconColor = Colors.purple;
        break;

      default:
        icon = Icons.circle_notifications;
        iconColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor.withOpacity(.12),
            child: Icon(icon, size: 18, color: iconColor),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employeeName, style: const TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 2),

                Text(activity['title'] ?? '', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              ],
            ),
          ),

          Text(DateFormatter.formatTime(activity['activity_time']?.toString()), style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}
