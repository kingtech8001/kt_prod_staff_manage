import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../controller/dashboard_controller.dart';

class UpcomingHolidaysCard extends StatelessWidget {
  const UpcomingHolidaysCard({super.key});

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
          Obx(() {
            if (controller.holidays.isEmpty) {
              return const Text('No upcoming holidays', style: TextStyle(color: Color(0xFF64748B)));
            }

            return Column(
              children: controller.holidays.map((holiday) {
                final date = DateTime.parse(holiday['holiday_date']);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),

                  child: _holidayItem(
                    date: DateFormatter.formatMonthDay(holiday['holiday_date']?.toString()),
                    title: holiday['title'],
                    subtitle: holiday['holiday_type'],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _holidayItem({required String date, required String title, required String subtitle}) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

              const SizedBox(height: 4),

              Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
            ],
          ),
        ),
      ],
    );
  }

  String _month(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month];
  }
}
