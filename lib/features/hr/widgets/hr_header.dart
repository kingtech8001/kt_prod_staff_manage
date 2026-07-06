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

                return CompositedTransformTarget(
                  link: searchOverlay.layerLink,
                  child: TextField(
                    onChanged: (value) async {
                      directory.updateSearch(value);

                      await Future.delayed(const Duration(milliseconds: 450));

                      if (value.trim().isEmpty) {
                        searchOverlay.hide();
                        return;
                      }

                      if (directory.employees.isEmpty) {
                        searchOverlay.show(
                          context: context,
                          child: const Padding(
                            padding: EdgeInsets.all(18),
                            child: Center(
                              child: Text(
                                "No employee found",
                                style: TextStyle(color: Color(0xFF64748B)),
                              ),
                            ),
                          ),
                        );

                        return;
                      }

                      searchOverlay.show(
                        context: context,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: directory.employees.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final employee = directory.employees[index];

                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  employee['full_name']
                                      .toString()
                                      .split(' ')
                                      .map((e) => e[0])
                                      .take(2)
                                      .join(),
                                ),
                              ),
                              title: Text(employee['full_name']),
                              subtitle: Text(employee['designation'] ?? ''),
                              onTap: () async {
                                searchOverlay.hide();

                                FocusScope.of(context).unfocus();

                                directory.updateSearch('');

                                final management =
                                    Get.find<EmployeeManagementController>();

                                await management.openEmployeeProfile(
                                  Map<String, dynamic>.from(employee),
                                );
                              },
                            );
                          },
                        ),
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

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black,
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
