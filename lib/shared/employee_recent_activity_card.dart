import 'package:flutter/material.dart';
import 'package:staff_managememt_system/core/widgets/view_all_button.dart';

import '../core/utils/date_formatter.dart';

class EmployeeRecentActivityCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> activities;
  final VoidCallback onViewAll;

  const EmployeeRecentActivityCard({
    super.key,
    required this.title,
    required this.activities,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 18),

          if (activities.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  "No recent activities",
                  style: TextStyle(color: Color(0xFF64748B)),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: activities.take(3).length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final activity = activities.take(3).toList()[index];

                  final employee =
                      activity['employee'] as Map<String, dynamic>?;

                  final fullName =
                      employee?['full_name']?.toString() ?? 'Unknown';

                  return _ActivityTile(
                    avatar: fullName.substring(0, 1).toUpperCase(),
                    name: fullName,
                    action: activity['title'] ?? '',
                    time: DateFormatter.formatRelativeTime(
                      activity['activity_time']?.toString(),
                    ),
                  );
                },
              ),
            ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: .infinity,
            child: ViewAllButton(onPressed: onViewAll),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String avatar;
  final String name;
  final String action;
  final String time;

  const _ActivityTile({
    required this.avatar,
    required this.name,
    required this.action,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE9EDF5),
          child: Text(
            avatar,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1633),
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                action,
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),

        Text(
          time,
          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        ),
      ],
    );
  }
}
