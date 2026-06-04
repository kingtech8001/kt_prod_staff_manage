import 'package:flutter/material.dart';

class PerformanceStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const PerformanceStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),

          const SizedBox(height: 12),

          Text(
            value,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
