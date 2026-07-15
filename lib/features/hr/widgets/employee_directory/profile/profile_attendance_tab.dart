import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../controller/employee_profile_controller.dart';

class ProfileAttendanceTab extends StatefulWidget {
  const ProfileAttendanceTab({super.key});

  @override
  State<ProfileAttendanceTab> createState() => _ProfileAttendanceTabState();
}

class _ProfileAttendanceTabState extends State<ProfileAttendanceTab> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      final controller = Get.find<EmployeeProfileController>();

      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 250 &&
          controller.hasMoreAttendance.value &&
          !controller.isLoadingAttendance.value) {
        controller.loadMoreAttendance();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeProfileController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ),
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
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Attendance History',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),

                Obx(() {
                  final month = controller.selectedMonth.value;

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: Get.context!,
                        initialDate: month,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        initialDatePickerMode: DatePickerMode.year,
                      );

                      if (picked != null) {
                        controller.changeAttendanceMonth(
                          DateTime(picked.year, picked.month),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_month_outlined, size: 18),

                          const SizedBox(width: 10),

                          Text(
                            DateFormat('MMMM yyyy').format(month),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),

                          const SizedBox(width: 8),

                          const Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          const Divider(height: 1),

          _header(),

          const Divider(height: 1),

          ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                controller.attendanceHistory.length +
                (controller.hasMoreAttendance.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.attendanceHistory.length) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return _row(controller.attendanceHistory[index]);
            },
          ),
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
          Expanded(
            flex: 2,
            child: Text(
              DateFormatter.formatDate(
                attendance['attendance_date']?.toString(),
              ),
            ),
          ),

          Expanded(
            child: Text(
              DateFormatter.formatTime(attendance['punch_in']?.toString()),
            ),
          ),

          Expanded(
            child: Text(
              DateFormatter.formatTime(attendance['punch_out']?.toString()),
            ),
          ),

          Expanded(
            child: Text(
              ((attendance['total_hours'] ?? 0) as num).toStringAsFixed(1),
            ),
          ),

          Expanded(
            child: Text(
              ((attendance['overtime_hours'] ?? 0) as num).toStringAsFixed(1),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
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
