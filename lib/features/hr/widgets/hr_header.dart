import 'package:flutter/material.dart';

class HrHeader extends StatelessWidget {
  const HrHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HR Operations Center',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
                ),

                const SizedBox(height: 4),

                Text(_formattedDate(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
              ],
            ),
          ),

          SizedBox(
            width: 320,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search employees...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.notifications_none_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  static String _formattedDate() {
    final now = DateTime.now();

    const months = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    return '${months[now.month]} ${now.day}, ${now.year}';
  }
}
