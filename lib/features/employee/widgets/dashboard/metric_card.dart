import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/attendance_controller.dart';
import '../../controller/dashboard_controller.dart';

class BottomMetricsRow extends StatelessWidget {
  const BottomMetricsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceController = Get.find<AttendanceController>();
    final dashboardController = Get.find<DashboardController>();

    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: MetricCard(
              title: 'Attendance Reliability',
              value:
                  '${attendanceController.attendancePercentage.value.toStringAsFixed(0)}%',
              icon: Icons.verified_outlined,
              iconColor: Colors.green,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: MetricCard(
              title: 'Leave Balance',
              value: '${dashboardController.leaveBalanceDays.value} Days',
              icon: Icons.event_available_outlined,
              iconColor: Colors.blue,
            ),
          ),

          const SizedBox(width: 20),

          /*Expanded(
            child: MetricCard(
              title: 'Overtime Hours',
              value:
                  '${dashboardController.overtimeHours.value.toStringAsFixed(1)}h',
              icon: Icons.schedule_outlined,
              iconColor: Colors.orange,
            ),
          ),*/
        ],
      );
    });
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
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
