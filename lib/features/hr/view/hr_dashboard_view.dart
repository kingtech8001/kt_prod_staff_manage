import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../employee/widgets/dashboard/attendance_table.dart';
import '../../employee/widgets/dashboard/company_announcements_card.dart';
import '../../employee/widgets/dashboard/quick_status_row.dart';
import '../../employee/widgets/dashboard/recent_activity_card.dart';
import '../../employee/widgets/dashboard/shift_card.dart';
import '../../employee/widgets/dashboard/upcoming_holidays_card.dart';
import '../controller/hr_controller.dart';

class HrDashboardView extends StatelessWidget {
  const HrDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final hrController = Get.find<HrController>();
    return Container(
      color: const Color(0xFFF5F7FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  ShiftCard(),

                  const SizedBox(height: 24),

                  const QuickStatsRow(),

                  const SizedBox(height: 24),

                  const AttendanceTable(),
                ],
              ),
            ),

            const SizedBox(width: 32),

            Expanded(
              flex: 3,
              child: Column(
                children: [
                  CompanyAnnouncementsCard(
                    onViewAll: () {
                      hrController.changeIndex(4);
                    },
                  ),

                  const SizedBox(height: 24),

                  const UpcomingHolidaysCard(),

                  const SizedBox(height: 24),

                  RecentActivityCard(
                    onViewAll: () {
                      hrController.changeIndex(5);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
