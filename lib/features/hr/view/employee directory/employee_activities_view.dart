import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../controller/employee_profile_controller.dart';

class EmployeeActivitiesView extends StatelessWidget {
  const EmployeeActivitiesView({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeProfileController>();

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

                  const Text(
                    'Employee Activities',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (controller.activities.isEmpty &&
                      !controller.isLoadingActivities.value) {
                    return const Center(
                      child: Text(
                        'No activities available',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: controller.activities.length,
                    separatorBuilder: (_, __) => const Divider(height: 18),
                    itemBuilder: (context, index) {
                      final activity = controller.activities[index];

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

              const SizedBox(height: 5),

              Obx(() {
                if (controller.activities.isEmpty &&
                    !controller.isLoadingActivities.value) {
                  return const SizedBox();
                }

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
                    onPressed: controller.loadMoreActivities,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
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
