import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/activity_formatter.dart';
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

                      final employee =
                          controller.employee.value?['full_name'] ?? 'Employee';

                      final type = activity['activity_type'] ?? '';

                      return Container(
                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Container(
                              width: 52,
                              height: 52,

                              decoration: BoxDecoration(
                                color: ActivityIcon.color(
                                  type,
                                ).withValues(alpha: .12),

                                shape: BoxShape.circle,
                              ),

                              child: Icon(
                                ActivityIcon.icon(type),
                                color: ActivityIcon.color(type),
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    ActivityFormatter.title(activity),

                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    ActivityFormatter.description(
                                      activity,
                                      employee,
                                    ),

                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF64748B),
                                      height: 1.5,
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  Text(
                                    DateFormatter.formatDateTime(
                                      activity['activity_time'],
                                    ),

                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
