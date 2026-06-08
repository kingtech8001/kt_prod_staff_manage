import 'package:flutter/material.dart';

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});

  Widget _buildItem({required String title, required String value}) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          _buildItem(title: 'Expected Hours', value: '8h'),

          _buildItem(title: 'Break Allowance', value: '1h'),
        ],
      ),
    );
  }
}
