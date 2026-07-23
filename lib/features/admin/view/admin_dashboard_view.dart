import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/employee/view/attendance_view.dart';
import '../../../shared/employee_management_controller.dart';
import '../../../shared/employee_recent_activity_card.dart';
import '../../employee/widgets/dashboard/attendance_table.dart';
import '../../employee/widgets/dashboard/shift_card.dart';
import '../controller/admin_dashboard_controller.dart';
import 'employee_activity_list_view.dart';

class AdminDashboardView extends StatelessWidget {
  AdminDashboardView({super.key});

  final controller = Get.put(AdminDashboardController());

  @override
  Widget build(BuildContext context) {
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

                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Total Employees',
                            value: controller.totalEmployees.value.toString(),
                            icon: Icons.people_outline,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: StatCard(
                            title: 'HR Managers',
                            value: controller.totalHrManagers.value.toString(),
                            icon: Icons.badge_outlined,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: StatCard(
                            title: 'Present Today',
                            value: controller.presentToday.value.toString(),
                            icon: Icons.check_circle_outline,
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: StatCard(
                            title: 'Pending Leaves',
                            value: controller.pendingLeaves.value.toString(),
                            icon: Icons.event_note_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const AttendanceViewTable(),
                ],
              ),
            ),

            const SizedBox(width: 32),

            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Obx(() {
                    return EmployeeRecentActivityCard(
                      title: "Recent Employee Activity",
                      activities: controller.employeeActivities.toList(),
                      onViewAll: () {
                        controller.openEmployeeActivities();
                        final management =
                            Get.find<EmployeeManagementController>();
                        management.openAdminActivity();
                      },
                    );
                  }),

                  const SizedBox(height: 24),

                  Obx(() {
                    return EmployeeRecentActivityCard(
                      title: "Recent Hr Activity",
                      activities: controller.hrActivities.toList(),
                      onViewAll: () {
                        controller.openHrActivities();
                        final management =
                            Get.find<EmployeeManagementController>();
                        management.openAdminActivity();
                      },
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),

          const SizedBox(height: 16),

          Text(
            value,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(title, style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}
