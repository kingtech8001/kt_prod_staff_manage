import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_managememt_system/features/employee/widgets/dashboard/upcoming_holidays_card.dart';

import '../../../auth/controller/leave_controller.dart';

class LeaveSidebar extends StatelessWidget {
  const LeaveSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          LeaveBalanceCard(),
          SizedBox(height: 20),
          UpcomingHolidaysCard(),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),

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

  const _BalanceTile({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),

        const SizedBox(width: 12),

        Expanded(
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Recent Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),

          SizedBox(height: 20),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.schedule, color: Colors.orange),
            title: Text('Leave Submitted'),
            subtitle: Text('Today'),
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Leave Approved'),
            subtitle: Text('Yesterday'),
          ),
        ],
      ),
    );
  }
}
