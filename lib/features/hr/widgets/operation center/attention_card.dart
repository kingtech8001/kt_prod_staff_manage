import 'package:flutter/material.dart';

class AttentionCard extends StatelessWidget {
  final String title;
  final String description;
  final String actionText;
  final Color color;
  final IconData icon;

  const AttentionCard({super.key, required this.title, required this.description, required this.actionText, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            // backgroundColor: color.withValues(alpha: .12),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            child: Icon(icon),
          ),

          const SizedBox(height: 16),

          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),

          const SizedBox(height: 8),

          Text(description, style: const TextStyle(color: Color(0xFF64748B), height: 1.4)),

          const Spacer(),

          Align(
            alignment: .bottomEnd,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(actionText),
            ),
          ),
        ],
      ),
    );
  }
}
