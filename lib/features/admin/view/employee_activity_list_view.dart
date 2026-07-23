import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/date_formatter.dart';
import '../controller/admin_dashboard_controller.dart';

class EmployeeActivityListView extends StatelessWidget {
  final VoidCallback onBack;

  EmployeeActivityListView({super.key, required this.onBack}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadEmployeeActivities(role: 'Employee');
      }
    });
  }

  final controller = Get.find<AdminDashboardController>();
  final ScrollController scrollController = ScrollController();

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
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),

                  const SizedBox(width: 12),

                  Obx(
                    () => Text(
                      controller.selectedActivityView.value ==
                              ActivityViewType.employee
                          ? "Employee Activities"
                          : "HR Activities",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  final activities =
                      controller.selectedActivityView.value ==
                          ActivityViewType.employee
                      ? controller.employeeActivities
                      : controller.hrActivities;

                  if (activities.isEmpty) {
                    return Center(
                      child: Text(
                        controller.selectedActivityView.value ==
                                ActivityViewType.employee
                            ? "No employee activities"
                            : "No HR activities",
                        style: const TextStyle(color: Color(0xFF64748B)),
                      ),
                    );
                  }

                  return ListView.separated(
                    controller: scrollController,
                    itemCount:
                        activities.length +
                        (controller.hasMoreEmployeeActivities.value ? 1 : 0),
                    separatorBuilder: (_, __) => const Divider(height: 16),

                    itemBuilder: (context, index) {
                      if (index == activities.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final activity = activities[index];

                      final employee =
                          activity['employee'] as Map<String, dynamic>?;

                      final fullName =
                          employee?['full_name']?.toString() ?? 'Unknown';

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFFE9EDF5),
                          child: Text(
                            fullName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0B1633),
                            ),
                          ),
                        ),

                        title: Text(
                          fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            activity['title'] ?? '',
                            style: const TextStyle(color: Color(0xFF64748B)),
                          ),
                        ),

                        trailing: Text(
                          DateFormatter.formatDateTime(
                            activity['activity_time']?.toString(),
                          ),
                          style: const TextStyle(color: Color(0xFF64748B)),
                        ),
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
