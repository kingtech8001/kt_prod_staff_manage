import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/attendance_controller.dart';

class AttendanceView extends StatelessWidget {
  AttendanceView({super.key});

  final controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: Padding(
        padding: const EdgeInsets.all(32),

        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
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
                    child: _summaryCard(
                      title: 'Absent Days',
                      value: controller.attendanceList
                          .where((e) => e['status'] == 'Absent')
                          .length
                          .toString(),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _summaryCard(
                      title: 'Total Hours',
                      value: controller.attendanceList
                          .fold<double>(
                            0,
                            (sum, item) => sum + (item['total_hours'] ?? 0).toDouble(),
                          )
                          .toString(),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _summaryCard(
                      title: 'Late Days',
                      value: controller.attendanceList
                          .where((e) => e['status'] == 'Late')
                          .length
                          .toString(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text('Date', style: TextStyle(fontWeight: FontWeight.w600)),
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
                                child: Text('Hours', style: TextStyle(fontWeight: FontWeight.w600)),
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

                        ...controller.attendanceList.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: Text(item['attendance_date'].toString())),

                                Expanded(
                                  child: Text(
                                    item['punch_in']?.toString().substring(11, 16) ?? '-',
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    item['punch_out']?.toString().substring(11, 16) ?? '-',
                                  ),
                                ),

                                Expanded(child: Text(item['total_hours'].toString())),

                                Expanded(
                                  child: Container(
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
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
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

          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
