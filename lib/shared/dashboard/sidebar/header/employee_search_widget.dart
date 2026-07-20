import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/hr/controller/employee_directory_controller.dart';
import '../../../../features/hr/widgets/employee_search_overlay.dart';
import '../../../employee_management_controller.dart';

class EmployeeSearchWidget extends StatelessWidget {
  EmployeeSearchWidget({super.key});

  final EmployeeSearchOverlay searchOverlay = EmployeeSearchOverlay();

  @override
  Widget build(BuildContext context) {
    final directory = Get.find<EmployeeDirectoryController>();

    return SizedBox(
      width: 320,
      child: Builder(
        builder: (context) {
          return CompositedTransformTarget(
            link: searchOverlay.layerLink,
            child: TextField(
              focusNode: directory.searchFocusNode,
              controller: directory.searchController,
              onChanged: (value) async {
                directory.updateSearch(value);

                if (value.trim().isEmpty) {
                  searchOverlay.hide();
                  return;
                }

                if (!searchOverlay.isShowing) {
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
                            border: Border.all(color: const Color(0xFFE2E8F0)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            border: Border.all(color: const Color(0xFFE2E8F0)),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          border: Border.all(color: const Color(0xFFE5E7EB)),
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

                                directory.searchController.clear();

                                directory.updateSearch('');

                                final management =
                                    Get.find<EmployeeManagementController>();

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
                                      backgroundColor: const Color(0xFFE2E8F0),
                                      foregroundColor: const Color(0xFF334155),
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
                }
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
    );
  }
}
