import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_binding.dart';
import '../../core/controllers/auth_controller.dart';
import 'dashboard_factory.dart';

class DashboardLayout extends StatelessWidget {
  const DashboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      DashboardBinding.initialize();
      final config = DashboardFactory.create(authController);

      return Scaffold(
        body: Row(
          children: [
            config.sidebarBuilder(),

            Expanded(
              child: Column(
                children: [
                  if (config.showHeader()) config.headerBuilder(),

                  Expanded(child: config.bodyBuilder()),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
