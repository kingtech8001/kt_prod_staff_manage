import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    final isPresent = status.toLowerCase() == 'present';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(attendance['attendance_date']?.toString() ?? '-')),

          Expanded(child: Text(attendance['check_in_time']?.toString() ?? '-')),

          Expanded(child: Text(attendance['check_out_time']?.toString() ?? '-')),

          Expanded(child: Text(attendance['work_hours']?.toString() ?? '-')),

          Expanded(child: Text(attendance['overtime_hours']?.toString() ?? '-')),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: isPresent ? const Color(0xFFE8F5E9) : const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(20)),
              child: Text(
                status,
                textAlign: TextAlign.center,
                style: TextStyle(color: isPresent ? Colors.green : Colors.red, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
