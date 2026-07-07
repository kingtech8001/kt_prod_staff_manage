import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/widgets/common_helper.dart';
import '../../../shared/employee_management_controller.dart';
import '../controller/employee_directory_controller.dart';
import '../controller/hr_controller.dart';
import 'employee_search_overlay.dart';

class HrHeader extends StatelessWidget {
  HrHeader({super.key});
  final EmployeeSearchOverlay searchOverlay = EmployeeSearchOverlay();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final controller = Get.find<HrController>();
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
                    controller.pageSubtitle.value.isEmpty
                        ? _formattedDate()
                        : controller.pageSubtitle.value,
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
            width: 320,
            child: Builder(
              builder: (context) {
                final directory = Get.find<EmployeeDirectoryController>();
                final searchController = TextEditingController();

                return CompositedTransformTarget(
                  link: searchOverlay.layerLink,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) async {
                      directory.updateSearch(value);

                      if (value.trim().isEmpty) {
                        searchOverlay.hide();
                        return;
                      }

                      searchOverlay.show(
                        context: context,
                        child: Obx(() {
                          if (directory.isSearching.value) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.3,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Searching employees",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Color(0xFF111827),
                                          ),
                                        ),

                                        SizedBox(height: 4),

                                        Text(
                                          "Looking for matching employees...",
                                          style: TextStyle(
                                            color: Color(0xFF64748B),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (directory.searchResults.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF7ED),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.person_search_rounded,
                                      color: Color(0xFFF59E0B),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "No employees found",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            color: Color(0xFF111827),
                                          ),
                                        ),

                                        SizedBox(height: 4),

                                        Text(
                                          "Try another name, employee ID or designation.",
                                          style: TextStyle(
                                            color: Color(0xFF64748B),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Container(
                            constraints: const BoxConstraints(maxHeight: 340),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shrinkWrap: true,
                              itemCount: directory.searchResults.length,
                              itemBuilder: (context, index) {
                                final employee = directory.searchResults[index];

                                return InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () async {
                                    searchOverlay.hide();

                                    FocusScope.of(context).unfocus();

                                    searchController.clear();

                                    directory.updateSearch('');

                                    final management =
                                        Get.find<
                                          EmployeeManagementController
                                        >();

                                    await management.openEmployeeProfile(
                                      Map<String, dynamic>.from(employee),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 22,
                                          backgroundColor: const Color(
                                            0xFFE2E8F0,
                                          ),
                                          foregroundColor: const Color(
                                            0xFF334155,
                                          ),
                                          child: Text(
                                            employee['full_name']
                                                .toString()
                                                .split(' ')
                                                .map((e) => e[0])
                                                .take(2)
                                                .join(),
                                          ),
                                        ),

                                        const SizedBox(width: 14),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                employee['full_name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              Text(
                                                employee['designation'] ?? '',
                                                style: const TextStyle(
                                                  color: Color(0xFF64748B),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 15,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: 'Search employees...',
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
              // TODO Open Profile
            },
          ),
        ],
      ),
    );
  }

  static String _formattedDate() {
    final now = DateTime.now();

    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[now.month]} ${now.day}, ${now.year}';
  }
}
