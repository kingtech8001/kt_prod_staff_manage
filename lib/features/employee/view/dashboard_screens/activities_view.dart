import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../controller/dashboard_controller.dart';
import '../../controller/employee_controller.dart';

class ActivitiesView extends StatefulWidget {
  const ActivitiesView({super.key});

  @override
  State<ActivitiesView> createState() => _ActivitiesViewState();
}

class _ActivitiesViewState extends State<ActivitiesView> {
  final controller = Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeController = Get.find<EmployeeController>();

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
                    onPressed: () {
                      employeeController.changeIndex(
                        EmployeeController.dashboard,
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "Recent Activities",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (controller.recentActivities.isEmpty) {
                    return const Center(
                      child: Text(
                        "No recent activities",
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: controller.recentActivities.length,

                    separatorBuilder: (_, __) => const Divider(height: 16),

                    itemBuilder: (context, index) {
                      final activity = controller.recentActivities[index];

                      return ListTile(
                        leading: const Icon(Icons.history, color: Colors.blue),

                        title: Text(
                          activity['title'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            DateFormatter.formatDateTime(
                              activity['activity_time']?.toString(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 20),

              Obx(() {
                if (controller.isLoadingActivities.value) {
                  return const CircularProgressIndicator();
                }

                if (!controller.hasMoreActivities.value) {
                  return const Text(
                    'No more activities',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }

                return SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),

                    onPressed: controller.loadMoreActivities,

                    child: const Text("Load More"),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
