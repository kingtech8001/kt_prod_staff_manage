import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/employee/view/attendance_view.dart';
import '../../controller/dashboard_controller.dart';
import '../../controller/employee_controller.dart';
import '../../widgets/dashboard/attendance_table.dart';
import '../../widgets/dashboard/company_announcements_card.dart';
import '../../widgets/dashboard/metric_card.dart';
import '../../widgets/dashboard/quick_status_row.dart';
import '../../widgets/dashboard/recent_activity_card.dart';
import '../../widgets/dashboard/shift_card.dart';
import '../../widgets/dashboard/upcoming_holidays_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(DashboardController());
    final employeeController = Get.put(EmployeeController());
    return Container(
      color: const Color(0xFFF5F7FA),
      child: Column(
        children: [
          Expanded(
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
                        QuickStatsRow(controller: dashboardController),
                        const SizedBox(height: 24),
                        const AttendanceViewTable(),
                        /*const SizedBox(height: 24),
                        const BottomMetricsRow(),*/
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
                            employeeController.changeIndex(
                              EmployeeController.announcements,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        UpcomingHolidaysCard(
                          onViewAll: () {
                            employeeController.changeIndex(
                              EmployeeController.holidays,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        RecentActivityCard(
                          onViewAll: () {
                            employeeController.changeIndex(
                              EmployeeController.activities,
                            );
                          },
                        ),
                      ],
                    ),
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
