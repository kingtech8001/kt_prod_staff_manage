import 'package:flutter/material.dart';

class HrStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const HrStatCard({super.key, required this.title, required this.value, required this.subtitle, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 10),

              Text(value, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),

              const Spacer(),

              const Icon(Icons.trending_up, size: 18, color: Colors.green),
            ],
          ),

          const Spacer(),

          const SizedBox(height: 4),

          Text(
            title,
            style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 2),

          Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}
