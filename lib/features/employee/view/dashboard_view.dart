import 'package:flutter/material.dart';
import '../widgets/dashboard/attendance_table.dart';
import '../widgets/dashboard/company_announcements_card.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/metric_card.dart';
import '../widgets/dashboard/quick_status_row.dart';
import '../widgets/dashboard/recent_activity_card.dart';
import '../widgets/dashboard/shift_card.dart';
import '../widgets/dashboard/upcoming_holidays_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: const Column(
        children: [
          DashboardHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [ShiftCard(), SizedBox(height: 24), QuickStatsRow(), SizedBox(height: 24), AttendanceTable(), SizedBox(height: 24), BottomMetricsRow()],
                    ),
                  ),

                  SizedBox(width: 32),
                  Expanded(
                    flex: 3,
                    child: Column(children: [CompanyAnnouncementsCard(), SizedBox(height: 24), UpcomingHolidaysCard(), SizedBox(height: 24), RecentActivityCard()]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
