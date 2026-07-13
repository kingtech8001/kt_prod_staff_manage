import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/common_helper.dart';
import '../controller/admin_controller.dart';
import '../controller/hr_directory_controller.dart';
import 'admin_employee_search_overlay.dart';

final AdminEmployeeSearchOverlay searchOverlay = AdminEmployeeSearchOverlay();

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();
    final hrController = Get.find<HrDirectoryController>();

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    controller.pageTitle.value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Obx(
                  () => Text(
                    controller.pageSubtitle.value,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 350,
            child: Builder(
              builder: (context) {
                final searchController = TextEditingController();

                return CompositedTransformTarget(
                  link: searchOverlay.layerLink,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      hrController.updateSearch(value);

                      // popup comes next
                    },
                    decoration: InputDecoration(
                      hintText: "Search HR Staff...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 20),

          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Get.dialog(
                Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.notifications_active_outlined,
                          size: 30,
                          color: Color(0xFF0B1633),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Notification system is coming soon.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B1633),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Get.back(),
                            child: const Text('Got It'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },

            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF111827),
              ),
            ),
          ),

          const SizedBox(width: 16),

          UserAvatarButton(
            onTap: () {
              // TODO Admin Profile
            },
          ),
        ],
      ),
    );
  }
}
