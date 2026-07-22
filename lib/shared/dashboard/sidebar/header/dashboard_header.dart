import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/auth_controller.dart';
import '../../../../core/widgets/common_helper.dart';
import 'header_config.dart';
import 'notification_button.dart';

class DashboardHeader extends StatelessWidget {
  final HeaderConfig config;

  const DashboardHeader({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

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
            child: Obx(() {
              final user = authController.currentUser.value;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getGreeting()}, ${user?.fullName ?? ''}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    user?.designation ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              );
            }),
          ),

          config.actionWidget,

          if (config.showNotification) ...[
            const SizedBox(width: 20),
            const NotificationButton(),
          ],

          const SizedBox(width: 16),

          UserAvatarButton(),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    }

    if (hour < 17) {
      return "Good Afternoon";
    }

    if (hour < 21) {
      return "Good Evening";
    }

    return "Good Night";
  }
}
