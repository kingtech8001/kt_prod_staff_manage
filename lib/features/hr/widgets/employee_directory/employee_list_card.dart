import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/employee_management_controller.dart';
import '../../controller/employee_directory_controller.dart';
import '../../controller/employee_profile_controller.dart';
import '../../controller/hr_controller.dart';
import '../../view/employee directory/employee_profile_view.dart';

class EmployeeListCard extends StatelessWidget {
  const EmployeeListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EmployeeDirectoryController>();

    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: controller.isLoadingEmployees.value
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: [
                  ...controller.employees.map(
                    (employee) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _EmployeeTile(employee),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Obx(() {
                    if (controller.isLoadingEmployees.value) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!controller.hasMoreEmployees.value) {
                      return const SizedBox();
                    }

                    return SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: controller.loadMoreEmployees,
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

class _EmployeeTile extends StatelessWidget {
  final Map employee;

  const _EmployeeTile(this.employee);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () async {
        final controller = Get.find<EmployeeManagementController>();
        await controller.openEmployeeProfile(
          Map<String, dynamic>.from(employee),
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
                employee['full_name']
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
                    employee['full_name'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${employee['designation']}',
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),

            _statusChip(employee['is_active'] == true ? 'Active' : 'Inactive'),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final active = status == 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8F5E9) : const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: active ? Colors.green : Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
