import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/date_formatter.dart';
import '../../../../../shared/month_year_picker_dialog.dart';
import '../../../controller/employee_profile_controller.dart';

class ProfileAttendanceTab extends StatefulWidget {
  const ProfileAttendanceTab({super.key});

  @override
  State<ProfileAttendanceTab> createState() => _ProfileAttendanceTabState();
}

class _ProfileAttendanceTabState extends State<ProfileAttendanceTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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

      return _attendanceTable(controller);
    });
  }

  Widget _attendanceTable(EmployeeProfileController controller) {
    return Container(
      height: 600,
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

                GetX<EmployeeProfileController>(
                  builder: (controller) {
                    final month = controller.selectedMonth.value;

                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded),
                            onPressed: () {
                              controller.changeAttendanceMonth(
                                DateTime(month.year, month.month - 1),
                              );
                            },
                          ),

                          InkWell(
                            borderRadius: BorderRadius.circular(10),

                            onTap: () async {
                              final selected = await showDialog<DateTime>(
                                context: context,

                                builder: (_) =>
                                    MonthYearPickerDialog(initialDate: month),
                              );

                              if (selected != null) {
                                controller.changeAttendanceMonth(selected);
                              }
                            },

                            child: SizedBox(
                              width: 165,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat("MMMM yyyy").format(month),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded),
                            onPressed:
                                month.year == DateTime.now().year &&
                                    month.month == DateTime.now().month
                                ? null
                                : () {
                                    controller.changeAttendanceMonth(
                                      DateTime(month.year, month.month + 1),
                                    );
                                  },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          _header(),

          const Divider(height: 1),

          Expanded(
            child: Obx(() {
              if (controller.isLoadingAttendance.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.attendanceHistory.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_busy_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "No attendance records",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "No records for ${DateFormat('MMMM yyyy').format(controller.selectedMonth.value)}",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.attendanceHistory.length,
                itemBuilder: (_, index) {
                  return _row(controller.attendanceHistory[index]);
                },
              );
            }),
          ),

          const Divider(height: 1),

          _buildPagination(controller),
        ],
      ),
    );
  }

  Widget _buildPagination(EmployeeProfileController controller) {
    final start = controller.attendanceHistory.isEmpty
        ? 0
        : controller.currentAttendancePage.value *
                  controller.rowsPerPage.value +
              1;

    final end = (start + controller.attendanceHistory.length - 1).clamp(
      0,
      controller.totalRecords.value,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          const Text(
            "Rows per page",
            style: TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                dropdownColor: Colors.white,
                value: controller.rowsPerPage.value,
                items: const [
                  DropdownMenuItem(value: 5, child: Text("5")),
                  DropdownMenuItem(value: 10, child: Text("10")),
                  DropdownMenuItem(value: 20, child: Text("20")),
                  DropdownMenuItem(value: 50, child: Text("50")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    controller.changeRowsPerPage(value);
                  }
                },
              ),
            ),
          ),

          const Spacer(),

          Text(
            "$start-$end of ${controller.totalRecords.value}",
            style: const TextStyle(color: Color(0xFF64748B)),
          ),

          const SizedBox(width: 20),

          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: controller.currentAttendancePage.value == 0
                ? null
                : controller.previousAttendancePage,
          ),

          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: end >= controller.totalRecords.value
                ? null
                : controller.nextAttendancePage,
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
            child: Text(DateFormatter.formatHours(attendance['total_hours'])),
          ),

          Expanded(
            child: Text(
              DateFormatter.formatHours(attendance['overtime_hours']),
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
