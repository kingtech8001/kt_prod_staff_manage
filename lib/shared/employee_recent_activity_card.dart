import 'package:flutter/material.dart';

class EmployeeRecentActivityCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> activities;
  final VoidCallback? onViewAll;

  const EmployeeRecentActivityCard({
    super.key,
    required this.title,
    required this.activities,
    this.onViewAll,
  });

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
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 24),

          if (activities.isEmpty)
            const Expanded(
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
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  final activity = activities[index];

                  return _ActivityTile(
                    avatar: (activity['actor_name'] ?? '?')
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
                    name: activity['actor_name'] ?? '',
                    action: activity['title'] ?? '',
                    time: activity['activity_time'] ?? '',
                  );
                },
              ),
            ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onViewAll,
              child: const Text("View All"),
            ),
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
          radius: 22,
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
