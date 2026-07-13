import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/hr_directory_controller.dart';

class HrStatsRow extends StatelessWidget {
  const HrStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HrDirectoryController>();

    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _StatCard(
              title: 'Total HR Staff',
              value: controller.totalHr.value.toString(),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _StatCard(
              title: 'Active',
              value: controller.activeHr.value.toString(),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _StatCard(
              title: 'Administrators',
              value: controller.managers.value.toString(),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _StatCard(
              title: 'HR Managers',
              value: controller.executives.value.toString(),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
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
          Text(title, style: const TextStyle(color: Color(0xFF64748B))),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
