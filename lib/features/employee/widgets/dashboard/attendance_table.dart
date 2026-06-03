import 'package:flutter/material.dart';

class AttendanceTable extends StatelessWidget {
  const AttendanceTable({super.key});

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
            'Weekly Attendance Breakdown',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          ),

          const SizedBox(height: 24),

          _tableHeader(),

          const Divider(height: 32),

          _tableRow(day: 'Mon, Oct 23', clockIn: '08:58 AM', clockOut: '06:05 PM', total: '9h 07m'),

          const Divider(),

          _tableRow(day: 'Tue, Oct 24', clockIn: '09:02 AM', clockOut: '06:10 PM', total: '9h 08m'),

          const Divider(),

          _tableRow(day: 'Wed, Oct 25', clockIn: '08:55 AM', clockOut: '06:00 PM', total: '9h 05m'),

          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('My Upcoming Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  ),

                  const SizedBox(height: 12),

                  const UpcomingScheduleCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'DAY',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            'CLOCK IN',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            'CLOCK OUT',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            'TOTAL',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _tableRow({required String day, required String clockIn, required String clockOut, required String total, bool showDivider = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(day)),

          Expanded(flex: 2, child: Text(clockIn)),

          Expanded(flex: 2, child: Text(clockOut)),

          Expanded(
            flex: 2,
            child: Text(total, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class UpcomingScheduleCard extends StatelessWidget {
  const UpcomingScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _scheduleItem(color: const Color(0xFF6366F1), title: 'Product Sync: Q4 Roadmap', subtitle: 'Today • 02:00 PM - 03:00 PM'),
          ),

          const SizedBox(width: 24),

          Expanded(
            child: _scheduleItem(color: const Color(0xFF10B981), title: 'Approved Leave: Personal Day', subtitle: 'Friday, Oct 27 • All Day'),
          ),
        ],
      ),
    );
  }

  Widget _scheduleItem({required Color color, required String title, required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 48,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 4),

            Text(subtitle, style: const TextStyle(color: Color(0xFF64748B))),
          ],
        ),
      ],
    );
  }
}
