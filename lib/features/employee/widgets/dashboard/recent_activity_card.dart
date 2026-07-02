import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/view_all_button.dart';
import '../../controller/dashboard_controller.dart';
import '../../controller/employee_controller.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key, required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 24),

          Obx(() {
            if (controller.recentActivities.isEmpty) {
              return const Text(
                'No recent activity',
                style: TextStyle(color: Color(0xFF64748B)),
              );
            }

            final activities = controller.recentActivities.take(2).toList();

            return Column(
              children: activities.map((activity) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _activityItem(
                    icon: Icons.history,
                    color: Colors.blue,
                    title: activity['title'] ?? '',
                    time: DateFormatter.formatDateTime(
                      activity['activity_time']?.toString(),
                    ),
                  ),
                );
              }).toList(),
            );
          }),

          Align(
            alignment: Alignment.centerRight,
            child: ViewAllButton(
              onPressed: () async {
                await controller.resetActivities();
                onViewAll();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                time,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
