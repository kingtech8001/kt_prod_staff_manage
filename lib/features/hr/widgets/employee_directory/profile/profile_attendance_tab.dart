import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../controller/employee_profile_controller.dart';

class ProfileAttendanceTab extends StatelessWidget {
  const ProfileAttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeProfileController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()),
        );
      }

      if (controller.attendanceHistory.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Center(child: Text('No attendance records found')),
        );
      }

      return _attendanceTable(controller);
    });
  }

  Widget _attendanceTable(EmployeeProfileController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.centerLeft,
            child: const Text('Attendance History', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          ),

          const Divider(height: 1),

          _header(),

          const Divider(height: 1),

          ...controller.attendanceHistory.map((attendance) => _row(attendance)),
        ],
      ),
    );
  }

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Date')),

          Expanded(child: Text('Punch In')),

          Expanded(child: Text('Punch Out')),

          Expanded(child: Text('Hours')),

          Expanded(child: Text('OT')),

          Expanded(child: Text('Status', textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _row(Map<String, dynamic> attendance) {
    final status = attendance['status']?.toString() ?? '';

    final statusLower = status.toLowerCase();

    Color bgColor;
    Color textColor;

    switch (statusLower) {
      case 'present':
        bgColor = const Color(0xFFE8F5E9);
        textColor = Colors.green;
        break;

      case 'leave':
        bgColor = const Color(0xFFF3E8FF);
        textColor = Colors.purple;
        break;

      default:
        bgColor = const Color(0xFFFFF1F2);
        textColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(DateFormatter.formatDate(attendance['attendance_date']?.toString()))),

          Expanded(child: Text(DateFormatter.formatTime(attendance['punch_in']?.toString()))),

          Expanded(child: Text(DateFormatter.formatTime(attendance['punch_out']?.toString()))),

          Expanded(child: Text(((attendance['total_hours'] ?? 0) as num).toStringAsFixed(1))),

          Expanded(child: Text(((attendance['overtime_hours'] ?? 0) as num).toStringAsFixed(1))),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
