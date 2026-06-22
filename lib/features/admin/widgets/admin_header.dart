import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/common_helper.dart';
import '../controller/admin_controller.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

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
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                  ),
                ),

                const SizedBox(height: 4),

                Obx(() => Text(controller.pageSubtitle.value, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13))),
              ],
            ),
          ),

          SizedBox(
            width: 350,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search HRs,Employees ",
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
            child: const Icon(Icons.notifications_none_rounded, color: Colors.black),
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
