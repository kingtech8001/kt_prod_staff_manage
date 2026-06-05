import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/auth_controller.dart';
import '../../../../core/utils/app_confirmation_dialog.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

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
                    'Good Morning, ${user?.fullName ?? ''}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    user?.designation ?? 'Employee',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              );
            }),
          ),

          ElevatedButton.icon(
            onPressed: () async {
              final confirmed = await Get.dialog<bool>(
                const AppConfirmationDialog(
                  title: 'Request Leave',
                  message:
                      'Do you want to create a new leave request?\n\n'
                      'You will be redirected to the leave request form.',
                  confirmText: 'Continue',
                  confirmColor: Color(0xFF0B1633),
                ),
              );

              if (confirmed == true) {
                Get.dialog(const LeaveRequestDialog());
              }
            },
            icon: const Icon(Icons.add_circle_outline, size: 18),
            label: const Text('Request Leave'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF64748B),
              foregroundColor: Colors.white,
              minimumSize: const Size(170, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),

          const SizedBox(width: 20),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              Get.dialog(
                Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
              child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF111827)),
            ),
          ),
        ],
      ),
    );
  }
}
