import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staff_managememt_system/shared/attendance_controller.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/month_year_picker_dialog.dart';
import '../../controller/dashboard_controller.dart';

class AttendanceTable extends StatelessWidget {
  const AttendanceTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AttendanceController());
    return Container(
      height: 700,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Attendance Records',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              const Spacer(),

              Obx(() {
                final month = controller.selectedMonth.value;

                return Container(
                  margin: EdgeInsets.all(10),
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
              }),
            ],
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Punch In',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Punch Out',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Duration',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'OT',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: controller.attendanceList.isEmpty
                ? Center(
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
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.attendanceList.length,
                    itemBuilder: (_, index) {
                      final item = controller.attendanceList[index];

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFFF1F5F9)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                DateFormatter.formatDate(
                                  item['attendance_date']?.toString(),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                DateFormatter.formatTime(
                                  item['punch_in']?.toString(),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                DateFormatter.formatTime(
                                  item['punch_out']?.toString(),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                DateFormatter.formatHours(
                                  item['total_hours'] as num?,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                DateFormatter.formatHours(
                                  item['total_hours'] as num?,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item['status'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  if (item['is_late'] == true)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'Late',
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          const Divider(height: 1),

          _buildPagination(controller),
        ],
      ),
    );
  }

  Widget _buildPagination(AttendanceController controller) {
    final start = controller.attendanceList.isEmpty
        ? 0
        : controller.currentAttendancePage.value *
                  controller.rowsPerPage.value +
              1;

    final end = (start + controller.attendanceList.length - 1).clamp(
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
              child: Obx(
                () => DropdownButton<int>(
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
          ),

          const Spacer(),

          Obx(
            () => Text(
              "$start-$end of ${controller.totalRecords.value}",
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),

          const SizedBox(width: 20),

          Obx(
            () => IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: controller.currentAttendancePage.value == 0
                  ? null
                  : controller.previousAttendancePage,
            ),
          ),

          Obx(
            () => IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: end >= controller.totalRecords.value
                  ? null
                  : controller.nextAttendancePage,
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingScheduleCard extends StatelessWidget {
  const UpcomingScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Obx(() {
        if (dashboardController.schedules.isEmpty) {
          return const Center(
            child: Text(
              'No upcoming schedules',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          );
        }

        return Column(
          children: dashboardController.schedules.take(5).map((schedule) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _scheduleItem(
                color: _getColor(schedule['event_type']),
                title: schedule['title'] ?? '',
                subtitle:
                    '${DateFormatter.formatDate(schedule['start_time']?.toString())} • ${DateFormatter.formatTime(schedule['start_time']?.toString())} - ${DateFormatter.formatTime(schedule['end_time']?.toString())}',
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Color _getColor(String? type) {
    switch (type) {
      case 'Meeting':
        return const Color(0xFF6366F1);

      case 'Review':
        return const Color(0xFF10B981);

      case 'Training':
        return Colors.orange;

      default:
        return Colors.blue;
    }
  }

  String formatDate(String? value) {
    if (value == null) return '';

    final date = DateTime.parse(value).toLocal();

    return '${date.day}/${date.month}/${date.year}';
  }

  String formatTime(String? value) {
    if (value == null) return '';

    final date = DateTime.parse(value).toLocal();

    return TimeOfDay.fromDateTime(date).format(Get.context!);
  }

  Widget _scheduleItem({
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

              const SizedBox(height: 4),

              Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
            ],
          ),
        ),
      ],
    );
  }
}
