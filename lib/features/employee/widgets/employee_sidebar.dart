import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../controller/employee_controller.dart';

class EmployeeSidebar extends StatelessWidget {
  EmployeeSidebar({super.key});

  final controller = Get.find<EmployeeController>();
  final authController = Get.find<AuthController>();

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
    {'title': 'Attendance', 'icon': Icons.access_time},
    {'title': 'Leave Requests', 'icon': Icons.event_note_outlined},
    {'title': 'Performance', 'icon': Icons.bar_chart},
    {'title': 'Company Policy', 'icon': Icons.description_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.work_rounded, size: 32, color: Color(0xFF0B1633)),
              SizedBox(width: 12),
              Text('ProWorkforce', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
            ],
          ),

          const SizedBox(height: 40),

          Expanded(
            child: Obx(() {
              final selectedIndex = controller.selectedIndex.value;

              return ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final isSelected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        controller.changeIndex(index);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(color: isSelected ? const Color(0xFFE9EDF5) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Icon(item['icon'], size: 20, color: const Color(0xFF1E293B)),

                            const SizedBox(width: 12),

                            Text(
                              item['title'],
                              style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: const Color(0xFF1E293B)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(18)),
            child: Obx(() {
              final user = authController.currentUser.value;

              return Row(
                children: [
                  CircleAvatar(child: Text(user?.fullName.substring(0, 1) ?? 'U')),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.fullName ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),

                      Text(user?.role ?? ''),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
