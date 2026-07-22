import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staff_managememt_system/features/employee/widgets/dashboard/upcoming_holidays_card.dart';

import '../../../auth/controller/leave_controller.dart';

class LeaveSidebar extends StatelessWidget {
  const LeaveSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          LeaveBalanceCard(),
          SizedBox(height: 20),
          UpcomingHolidaysCard(onViewAll: () {}),
          SizedBox(height: 20),
          RecentActivityCard(),
        ],
      ),
    );
  }
}

class LeaveBalanceCard extends StatelessWidget {
  const LeaveBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeaveController>();

    return Obx(() {
      final balance = controller.leaveBalance.value;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Leave Balance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            _BalanceTile(
              title: 'Annual Leave',
              value: '${balance?['annual_leave'] ?? 0} Days',
              color: Colors.blue,
            ),

            const SizedBox(height: 12),

            _BalanceTile(
              title: 'Sick Leave',
              value: '${balance?['sick_leave'] ?? 0} Days',
              color: Colors.orange,
            ),

            const SizedBox(height: 12),

            _BalanceTile(
              title: 'Casual Leave',
              value: '${balance?['casual_leave'] ?? 0} Days',
              color: Colors.green,
            ),
          ],
        ),
      );
    });
  }
}

class _BalanceTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _BalanceTile({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),

        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeaveController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            if (controller.recentLeaveActivities.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No recent leave activity',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ),
              )
            else
              ...controller.recentLeaveActivities.map((activity) {
                final status = activity['status'] ?? '';

                IconData icon;
                Color color;

                switch (status.toLowerCase()) {
                  case 'approved':
                    icon = Icons.check_circle;
                    color = Colors.green;
                    break;

                  case 'rejected':
                    icon = Icons.cancel;
                    color = Colors.red;
                    break;

                  default:
                    icon = Icons.schedule;
                    color = Colors.orange;
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero,

                  leading: Icon(icon, color: color),

                  title: Text(
                    activity['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),

                  subtitle: Text(activity['time'] ?? ''),
                );
              }),
          ],
        );
      }),
    );
  }
}
