import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controller/performance_controller.dart';
import '../widgets/performance/performance_metrics_card.dart';
import '../widgets/performance/performance_sidebar.dart';
import '../widgets/performance/performance_stat_card.dart';

class PerformanceView extends StatelessWidget {
  PerformanceView({super.key});

  final controller = Get.put(PerformanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Performance Overview',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => PerformanceStatCard(
                      title: 'Attendance',
                      value: '${controller.attendancePercent.value.toStringAsFixed(0)}%',
                      color: Colors.green,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Obx(
                    () => PerformanceStatCard(
                      title: 'Leaves Taken',
                      value: controller.leavesTaken.value.toString(),
                      color: Colors.orange,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Obx(
                    () => PerformanceStatCard(
                      title: 'Working Days',
                      value: controller.workingDays.value.toString(),
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Obx(
                    () => PerformanceStatCard(
                      title: 'Rating',
                      value: controller.averageRating.value.toStringAsFixed(1),
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Expanded(flex: 3, child: PerformanceMetricsCard()),

                  const SizedBox(width: 24),

                  const Expanded(flex: 1, child: PerformanceSidebar()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
