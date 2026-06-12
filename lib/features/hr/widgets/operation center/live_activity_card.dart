import 'package:flutter/material.dart';

class LiveActivityCard extends StatelessWidget {
  const LiveActivityCard({super.key});

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
          const Text('Live Activity Feed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: const [
                ActivityItem(icon: Icons.login, title: 'John Smith punched in', time: '2 mins ago'),

                ActivityItem(icon: Icons.logout, title: 'Sarah Wilson punched out', time: '10 mins ago'),

                ActivityItem(icon: Icons.event_available, title: 'Leave request approved', time: '20 mins ago'),

                ActivityItem(icon: Icons.person_add, title: 'New employee added', time: '1 hour ago'),

                ActivityItem(icon: Icons.warning_amber, title: 'Attendance violation detected', time: '2 hours ago'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final String title;
  final String time;

  const ActivityItem({super.key, required this.icon, this.color, required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: Color(0xFF64748B), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 4),

                Text(time, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
