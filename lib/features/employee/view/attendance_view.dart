import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/attendance_controller.dart';
import '../../../core/utils/date_formatter.dart';
import '../widgets/attendance/attendance_sidebar.dart';
import 'package:intl/intl.dart';
import '../../../shared/month_year_picker_dialog.dart';

class AttendanceView extends StatelessWidget {
  AttendanceView({super.key});

  final controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Attendance History',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => _summaryCard(
                        title: 'Attendance %',
                        value:
                            '${controller.attendancePercentage.value.toStringAsFixed(0)}%',
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _summaryCard(
                      title: 'Present Days',
                      value: controller.attendanceList
                          .where((e) => e['status'] == 'Present')
                          .length
                          .toString(),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Obx(
                      () => _summaryCard(
                        title: 'Late Days',
                        value: controller.lateDays.value.toString(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Obx(
                      () => _summaryCard(
                        title: 'Overtime',
                        value:
                            '${controller.overtimeHours.value.toStringAsFixed(1)} h',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: AttendanceViewTable()),

                  const SizedBox(width: 24),

                  const Expanded(flex: 1, child: AttendanceSidebar()),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _summaryCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF64748B))),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AttendanceViewTable extends StatelessWidget {
  const AttendanceViewTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AttendanceController>();

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
            child: Obx(() {
              if (controller.isLoadingAttendance.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.attendanceList.isEmpty) {
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
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.attendanceList.length,
                itemBuilder: (_, index) {
                  final item = controller.attendanceList[index];

                  final status = (item['status'] ?? '')
                      .toString()
                      .toLowerCase();

                  Color badgeColor;
                  Color textColor;

                  switch (status) {
                    case 'present':
                      badgeColor = const Color(0xFFE8F5E9);
                      textColor = Colors.green;
                      break;

                    case 'leave':
                      badgeColor = const Color(0xFFE3F2FD);
                      textColor = Colors.blue;
                      break;

                    case 'absent':
                      badgeColor = Colors.red.shade100;
                      textColor = Colors.red;
                      break;

                    default:
                      badgeColor = Colors.grey.shade200;
                      textColor = Colors.grey.shade700;
                  }
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
                              item['overtime_hours'] as num?,
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
                                  color: badgeColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Text(
                                  item['status'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: textColor,
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
              );
            }),
          ),

          const Divider(height: 1),

          _buildPagination(controller),
        ],
      ),
    );
  }

  Widget _buildPagination(AttendanceController controller) {
    return Obx(() {
      final total = controller.totalRecords.value;
      final page = controller.currentAttendancePage.value;
      final rows = controller.rowsPerPage.value;
      final count = controller.attendanceList.length;

      final start = total == 0 ? 0 : page * rows + 1;

      final end = total == 0 ? 0 : (page * rows + count).clamp(1, total);

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
                  value: rows,
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
              "$start-$end of $total",
              style: const TextStyle(color: Color(0xFF64748B)),
            ),

            const SizedBox(width: 20),

            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: page == 0 ? null : controller.previousAttendancePage,
            ),

            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: end >= total ? null : controller.nextAttendancePage,
            ),
          ],
        ),
      );
    });
  }
}
