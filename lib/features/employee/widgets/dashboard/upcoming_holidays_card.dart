import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/view_all_button.dart';
import '../../controller/dashboard_controller.dart';

class UpcomingHolidaysCard extends StatelessWidget {
  final VoidCallback onViewAll;

  const UpcomingHolidaysCard({super.key, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Container(
      width: double.infinity,
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
            'Upcoming Holidays',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 24),
          Obx(() {
            if (controller.holidays.isEmpty) {
              return const Text(
                'No upcoming holidays',
                style: TextStyle(color: Color(0xFF64748B)),
              );
            }

            return Column(
              children: controller.holidays.take(3).map((holiday) {
                final date = DateTime.parse(holiday['holiday_date']);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),

                  child: _holidayItem(
                    date: DateFormatter.formatMonthDay(
                      holiday['holiday_date']?.toString(),
                    ),
                    title: holiday['title'],
                    subtitle: holiday['holiday_type'],
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: ViewAllButton(
              onPressed: () async {
                onViewAll();
                await controller.resetHolidays();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _holidayItem({
    required String date,
    required String title,
    required String subtitle,
  }) {
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

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

class HolidaysView extends StatefulWidget {
  const HolidaysView({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<HolidaysView> createState() => _HolidaysViewState();
}

class _HolidaysViewState extends State<HolidaysView> {
  final controller = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetHolidays();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Upcoming Holidays",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (controller.holidays.isEmpty) {
                    return const Center(
                      child: Text(
                        "No upcoming holidays",
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    );
                  }

                  return ListView.separated(
                    controller: controller.holidayScrollController,

                    itemCount:
                        controller.holidays.length +
                        (controller.isLoadingHolidays.value ? 1 : 0),

                    separatorBuilder: (_, __) => const Divider(height: 16),

                    itemBuilder: (context, index) {
                      if (index >= controller.holidays.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final holiday = controller.holidays[index];

                      return ListTile(
                        leading: Container(
                          width: 55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            DateFormatter.formatMonthDay(
                              holiday['holiday_date']?.toString(),
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        title: Text(
                          holiday['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),

                        subtitle: Text(holiday['holiday_type']),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
