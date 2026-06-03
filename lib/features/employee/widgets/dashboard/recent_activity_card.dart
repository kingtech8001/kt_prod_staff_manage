import 'package:flutter/material.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),

          const SizedBox(height: 24),

          _activityItem(icon: Icons.login, color: Colors.green, title: 'Punch In Recorded', time: 'Today • 09:01 AM'),

          const SizedBox(height: 20),

          _activityItem(icon: Icons.coffee, color: Colors.orange, title: 'Break Started', time: 'Today • 01:00 PM'),

          const SizedBox(height: 20),

          _activityItem(icon: Icons.coffee_outlined, color: Colors.blue, title: 'Break Ended', time: 'Today • 01:30 PM'),

          const SizedBox(height: 20),

          _activityItem(icon: Icons.event_note_outlined, color: Colors.purple, title: 'Leave Request Submitted', time: 'Yesterday'),
        ],
      ),
    );
  }

  Widget _activityItem({required IconData icon, required Color color, required String title, required String time}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: color, size: 20),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),

              const SizedBox(height: 4),

              Text(time, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            ],
          ),
        ),
      ],
    );
  }
}
