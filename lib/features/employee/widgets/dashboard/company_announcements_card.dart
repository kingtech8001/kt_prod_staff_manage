import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/view_all_button.dart';
import '../../controller/dashboard_controller.dart';
import '../../controller/employee_controller.dart';
import '../../view/dashboard_screens/announcements_view.dart';

class CompanyAnnouncementsCard extends StatelessWidget {
  CompanyAnnouncementsCard({super.key});

  final controller = Get.put(DashboardController());
  final employeeController = Get.find<EmployeeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Align(
            alignment: .centerLeft,
            child: const Text(
              'Company Announcements',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Obx(() {
            if (controller.announcements.isEmpty) {
              return const Text(
                'No announcements available',
                style: TextStyle(color: Color(0xFF64748B)),
              );
            }
            final announcements = controller.announcements.take(2).toList();

            return Column(
              children: List.generate(announcements.length, (index) {
                final item = announcements[index];

                return Column(
                  children: [
                    _announcementItem(
                      icon: Icons.campaign_outlined,
                      iconColor: Colors.blue,
                      title: item['title'] ?? '',
                      description: item['description'] ?? '',
                    ),

                    if (index != controller.announcements.length - 1)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(height: 1),
                      ),
                  ],
                );
              }),
            );
          }),
          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: ViewAllButton(
              onPressed: () async {
                employeeController.changeIndex(
                  EmployeeController.announcements,
                );
                await controller.resetAnnouncements();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _announcementItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                description,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
