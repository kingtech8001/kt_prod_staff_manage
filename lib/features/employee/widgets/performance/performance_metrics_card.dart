import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/attendance_controller.dart';
import '../../../auth/controller/performance_controller.dart';

class PerformanceMetricsCard extends StatelessWidget {
  const PerformanceMetricsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final performanceController = Get.find<PerformanceController>();
    final attendanceController = Get.find<AttendanceController>();
    final controller = Get.find<PerformanceController>();

    return Obx(() {
      final metrics = controller.performanceMetrics.value;

      return Container(
        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 30),

            Obx(
              () => PerformanceMetricTile(
                title: 'Attendance Rate',
                value: attendanceController.attendancePercentage.value / 100,
                color: const Color(0xFF64748B),
              ),
            ),

            const SizedBox(height: 24),

            PerformanceMetricTile(
              title: 'Punctuality',
              value: ((metrics?['punctuality'] ?? 0) as num).toDouble() / 100,
              color: const Color(0xFF64748B),
            ),

            const SizedBox(height: 24),

            PerformanceMetricTile(
              title: 'Task Completion',
              value:
                  ((metrics?['task_completion'] ?? 0) as num).toDouble() / 100,
              color: const Color(0xFF64748B),
            ),

            const SizedBox(height: 24),

            PerformanceMetricTile(
              title: 'Team Collaboration',
              value:
                  ((metrics?['team_collaboration'] ?? 0) as num).toDouble() /
                  100,
              color: const Color(0xFF64748B),
            ),
          ],
        ),
      );
    });
  }
}

class PerformanceMetricTile extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const PerformanceMetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),

            const Spacer(),

            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
