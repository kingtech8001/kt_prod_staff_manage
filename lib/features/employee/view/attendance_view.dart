import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/attendance_controller.dart';
import '../widgets/attendance/attendance_insights.dart';
import '../widgets/attendance/attendance_sidebar.dart';

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
                  Expanded(
                    flex: 3,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 500),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Attendance Records',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFFE5E7EB)),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Date',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Punch In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Punch Out',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Duration',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    'OT',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ...controller.attendanceList.map((item) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 20,
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
                                      item['attendance_date'].toString(),
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(_formatTime(item['punch_in'])),
                                  ),

                                  Expanded(
                                    child: Text(_formatTime(item['punch_out'])),
                                  ),

                                  Expanded(
                                    child: Text(
                                      _formatDuration(
                                        ((item['total_hours'] ?? 0) as num)
                                            .toDouble(),
                                      ),
                                    ),
                                  ),

                                  Expanded(
                                    child: Text(
                                      _formatDuration(
                                        ((item['overtime_hours'] ?? 0) as num)
                                            .toDouble(),
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
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
                                            margin: const EdgeInsets.only(
                                              bottom: 6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                          }),
                        ],
                      ),
                    ),
                  ),

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

  String _formatTime(String? value) {
    if (value == null) return '-';

    final date = DateTime.parse(value).toLocal();

    return TimeOfDay.fromDateTime(date).format(Get.context!);
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

String _formatDuration(double hours) {
  if (hours <= 0) {
    return "0 min";
  }

  if (hours < 1) {
    final minutes = (hours * 60).round();
    return "$minutes min";
  }

  return "${hours.toStringAsFixed(1)} hrs";
}
