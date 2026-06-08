import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/attendance_controller.dart';

class AttendanceInsights extends StatelessWidget {
  const AttendanceInsights({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttendanceController>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Obx(
        () => Row(
          children: [
            Expanded(child: _item('Average Arrival', controller.averageArrivalTime.value)),
            Expanded(
              child: _item('Average Hours', controller.averageHours.value.toStringAsFixed(1)),
            ),
            Expanded(child: _item('Current Streak', '${controller.currentStreak.value} Days')),
            Expanded(
              child: _item(
                'Longest Day',
                '${controller.longestDayHours.value.toStringAsFixed(1)}h',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF64748B))),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
