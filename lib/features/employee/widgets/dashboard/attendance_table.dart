import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../controller/dashboard_controller.dart';

class AttendanceTable extends StatelessWidget {
  const AttendanceTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Attendance Breakdown',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),

          const SizedBox(height: 24),

          _tableHeader(),

          const Divider(height: 32),

          Obx(() {
            return Column(
              children: controller.attendanceHistory.take(7).map((item) {
                return Column(
                  children: [
                    _tableRow(
                      day: DateTime.parse(
                        item['attendance_date'],
                      ).toLocal().toString().split(' ')[0],
                      clockIn: formatTime(item['punch_in']),
                      clockOut: formatTime(item['punch_out']),
                      total: '${item['total_hours'] ?? 0}h',
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            );
          }),

          const SizedBox(height: 24),

          /*Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'My Upcoming Schedule',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const UpcomingScheduleCard(),
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'DAY',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            'CLOCK IN',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            'CLOCK OUT',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            'TOTAL',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _tableRow({
    required String day,
    required String clockIn,
    required String clockOut,
    required String total,
    bool showDivider = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(day)),

          Expanded(flex: 2, child: Text(clockIn)),

          Expanded(flex: 2, child: Text(clockOut)),

          Expanded(
            flex: 2,
            child: Text(total, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  String formatTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return '--';
    }

    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();

      return TimeOfDay.fromDateTime(dateTime).format(Get.context!);
    } catch (e) {
      return '--';
    }
  }
}

class UpcomingScheduleCard extends StatelessWidget {
  const UpcomingScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Obx(() {
        if (controller.schedules.isEmpty) {
          return const Center(
            child: Text('No upcoming schedules', style: TextStyle(color: Color(0xFF64748B))),
          );
        }

        return Column(
          children: controller.schedules.take(5).map((schedule) {
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

  Widget _scheduleItem({required Color color, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 48,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
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
