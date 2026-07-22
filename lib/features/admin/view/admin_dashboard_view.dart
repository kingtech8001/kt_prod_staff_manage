import 'package:flutter/material.dart';
import '../../employee/widgets/dashboard/attendance_table.dart';
import '../../employee/widgets/dashboard/shift_card.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7FA),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                children: [
                  ShiftCard(),

                  const SizedBox(height: 24),

                  Expanded(
                    flex: 3,
                    child: Row(
                      children: const [
                        StatCard(
                          title: 'Total Employees',
                          value: '124',
                          icon: Icons.people_outline,
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: StatCard(
                            title: 'HR Managers',
                            value: '8',
                            icon: Icons.badge_outlined,
                          ),
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: StatCard(
                            title: 'Present Today',
                            value: '118',
                            icon: Icons.check_circle_outline,
                          ),
                        ),

                        SizedBox(width: 16),

                        Expanded(
                          child: StatCard(
                            title: 'Pending Leaves',
                            value: '5',
                            icon: Icons.event_note_outlined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const AttendanceTable(),
                ],
              ),
            ),

            const SizedBox(width: 32),

            Expanded(
              flex: 3,
              child: Column(
                children: [
                  // RecentEmployeeActivityCard()
                  const SizedBox(height: 24),

                  // RecentHrActivityCard()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisAlignment: .start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),

          const SizedBox(height: 16),

          Text(
            value,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(title, style: const TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}
