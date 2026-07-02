import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/dashboard_controller.dart';
import '../../controller/employee_controller.dart';

class AnnouncementsView extends StatelessWidget {
  const AnnouncementsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
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
                    "Company Announcements",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (controller.announcements.isEmpty) {
                    return const Center(
                      child: Text(
                        "No announcements available",
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: controller.announcements.length,

                    separatorBuilder: (_, __) => const Divider(height: 16),

                    itemBuilder: (context, index) {
                      final item = controller.announcements[index];

                      return ListTile(
                        leading: const Icon(
                          Icons.campaign_outlined,
                          color: Colors.blue,
                        ),

                        title: Text(
                          item['title'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(item['description'] ?? ''),
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 20),

              Obx(() {
                if (controller.isLoadingAnnouncements.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!controller.hasMoreAnnouncements.value) {
                  return const Text(
                    'No more announcements',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }

                return SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.black),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                    ),
                    onPressed: controller.loadMoreAnnouncements,
                    child: const Text('Load More'),
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
