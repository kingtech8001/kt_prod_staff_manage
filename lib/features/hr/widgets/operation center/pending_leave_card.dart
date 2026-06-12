import 'package:flutter/material.dart';

class PendingLeaveCard extends StatelessWidget {
  const PendingLeaveCard({super.key});

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
          const Text('Pending Leave Requests', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _leaveItem(name: 'John Smith', type: 'Annual Leave', days: '3 Days'),

                  const Divider(),

                  _leaveItem(name: 'Sarah Wilson', type: 'Sick Leave', days: '1 Day'),

                  const Divider(),

                  _leaveItem(name: 'David Brown', type: 'Personal Leave', days: '2 Days'),

                  const Divider(),

                  _leaveItem(name: 'Michael Scott', type: 'Emergency Leave', days: '5 Days'),

                  const Divider(),

                  _leaveItem(name: 'Emily Davis', type: 'Annual Leave', days: '4 Days'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xFF64748b)), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: const Text('Review All Requests'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _leaveItem({required String name, required String type, required String days}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 18, backgroundColor: Color(0xFF64748b), foregroundColor: Colors.white, child: Text(name[0])),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),

                Text(type, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ],
            ),
          ),

          Text(days, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
