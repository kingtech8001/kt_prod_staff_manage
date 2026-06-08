import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/attendance_controller.dart';

class AttendanceSidebar extends StatelessWidget {
  const AttendanceSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttendanceController>();

    return Obx(
      () => Container(
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
            const Text(
              'Attendance Overview',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 24),

            _row('Attendance Rate', '${controller.attendancePercentage.value.toStringAsFixed(0)}%'),

            _row(
              'Present Days',
              controller.attendanceList.where((e) => e['status'] == 'Present').length.toString(),
            ),

            _row('Late Days', controller.lateDays.value.toString()),

            _row('Working Days', controller.workingDays.value.toString()),

            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),

            _row('Average Arrival', controller.averageArrivalTime.value),

            _row('Average Hours', '${controller.averageHours.value.toStringAsFixed(1)} h'),

            _row('Current Streak', '${controller.currentStreak.value} Days'),

            _row('Longest Day', '${controller.longestDayHours.value.toStringAsFixed(1)} h'),

            _row('Overtime', '${controller.overtimeHours.value.toStringAsFixed(1)} h'),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
