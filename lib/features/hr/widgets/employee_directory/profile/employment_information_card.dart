import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/employee_profile_controller.dart';
import '../../../controller/hr_controller.dart';

class EmploymentInformationCard extends StatelessWidget {
  const EmploymentInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<EmployeeProfileController>();
      final employee = controller.employee.value;

      if (employee == null) {
        return const SizedBox();
      }
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Employment Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

            const SizedBox(height: 24),

            _infoRow('Employee Code', employee['employee_code']?.toString() ?? '-'),

            _infoRow('Full Name', employee['full_name']?.toString() ?? '-'),

            _infoRow('Email', employee['email']?.toString() ?? '-'),

            _infoRow('Phone', employee['phone']?.toString() ?? '-'),

            _infoRow('Designation', employee['designation']?.toString() ?? '-'),

            _infoRow('Role', employee['role']?.toString() ?? '-'),

            _infoRow('Status', employee['is_active'] == true ? 'Active' : 'Inactive'),
          ],
        ),
      );
    });
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          ),

          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
