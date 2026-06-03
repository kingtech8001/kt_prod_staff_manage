import 'package:flutter/material.dart';

class UpcomingHolidaysCard extends StatelessWidget {
  const UpcomingHolidaysCard({super.key});

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
            'Upcoming Holidays',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),

          const SizedBox(height: 24),

          _holidayItem(date: 'Nov 01', title: 'Diwali', subtitle: 'Company Holiday'),

          const SizedBox(height: 20),

          _holidayItem(date: 'Dec 25', title: 'Christmas', subtitle: 'Public Holiday'),

          const SizedBox(height: 20),

          _holidayItem(date: 'Jan 01', title: 'New Year', subtitle: 'Public Holiday'),
        ],
      ),
    );
  }

  Widget _holidayItem({required String date, required String title, required String subtitle}) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14)),
          child: Center(
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

              const SizedBox(height: 4),

              Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
            ],
          ),
        ),
      ],
    );
  }
}
