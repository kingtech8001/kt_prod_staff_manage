import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/common_helper.dart';
import '../controller/admin_controller.dart';

class AdminSidebar extends StatelessWidget {
  AdminSidebar({super.key});

  final controller = Get.find<AdminController>();

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Command Center', 'icon': Icons.dashboard_outlined},
    {'title': 'Employee Management', 'icon': Icons.people_outline},
    {'title': 'HR Management', 'icon': Icons.badge_outlined},
    {'title': 'Access Control', 'icon': Icons.admin_panel_settings_outlined},
    {'title': 'Audit Logs', 'icon': Icons.receipt_long_outlined},
    {'title': 'Settings', 'icon': Icons.settings_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
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

                            Expanded(
                              child: Text(
                                item['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: const Color(0xFF1E293B)),
                              ),
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

          const LogoutTile(),
        ],
      ),
    );
  }
}
