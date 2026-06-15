import 'package:flutter/material.dart';

class LiveActivityFeed extends StatelessWidget {
  LiveActivityFeed({super.key});

  final activities = [
    {'name': 'Sarah Jenkins', 'action': 'Checked In (Remote)', 'time': '2m ago', 'icon': Icons.login},
    {'name': 'Michael Chen', 'action': 'Started Break', 'time': '12m ago', 'icon': Icons.coffee},
    {'name': 'Jessica Alba', 'action': 'Submitted Leave Request', 'time': '45m ago', 'icon': Icons.event_note_outlined},
    {'name': 'David Miller', 'action': 'Punched Out (Office)', 'time': '1h ago', 'icon': Icons.logout},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Live Activity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

          const SizedBox(height: 20),

          ...activities.map((activity) => Padding(padding: const EdgeInsets.only(bottom: 18), child: _activityItem(activity))),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B1633),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('View All Activity'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityItem(Map<String, dynamic> activity) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFF64748b),
          child: Icon(activity['icon'], size: 18, color: Colors.white),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity['name'], style: const TextStyle(fontWeight: FontWeight.w600)),

              const SizedBox(height: 2),

              Text(activity['action'], style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
            ],
          ),
        ),

        Text(activity['time'], style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
      ],
    );
  }
}
