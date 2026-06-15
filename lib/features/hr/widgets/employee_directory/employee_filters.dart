/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/employee_directory_controller.dart';

class EmployeeFilters extends StatelessWidget {
  EmployeeFilters({super.key});

  final controller = Get.find<EmployeeDirectoryController>();

  final departments = ['All Staff', 'Engineering', 'Marketing', 'Operations'];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          ...departments.map((department) => Padding(padding: const EdgeInsets.only(right: 12), child: _chip(department, controller.selectedDepartment.value == department))),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _chip(String text, bool selected) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        controller.selectDepartment(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0B1633) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          text,
          style: TextStyle(color: selected ? Colors.white : const Color(0xFF0F172A), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
*/
