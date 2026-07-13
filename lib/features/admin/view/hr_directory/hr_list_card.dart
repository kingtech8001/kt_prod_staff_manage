import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/employee_management_controller.dart';
import '../../controller/hr_directory_controller.dart';

class HrListCard extends StatelessWidget {
  const HrListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HrDirectoryController>();

    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: controller.isLoadingHr.value
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  ...controller.hrStaff.map(
                    (hr) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _HrTile(hr),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Obx(() {
                    if (controller.isLoadingHr.value) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!controller.hasMoreHr.value) {
                      return const SizedBox();
                    }

                    return SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: controller.loadMoreHr,
                        child: const Text("Load More"),
                      ),
                    );
                  }),
                ],
              ),
      );
    });
  }
}

class _HrTile extends StatelessWidget {
  final Map hr;

  const _HrTile(this.hr);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        final management = Get.find<EmployeeManagementController>();

        await management.openEmployeeProfile(
          Map<String, dynamic>.from(hr),
          role: "HR",
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE2E8F0),
              child: Text(
                hr['full_name']
                    .toString()
                    .split(' ')
                    .map((e) => e[0])
                    .take(2)
                    .join(),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hr['full_name'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    hr['designation'] ?? '',
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),

            _statusChip(hr['is_active'] == true),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8F5E9) : const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? "Active" : "Inactive",
        style: TextStyle(
          color: active ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
