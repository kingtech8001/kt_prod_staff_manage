import 'package:flutter/material.dart';

class DepartmentAttendanceTable extends StatelessWidget {
  const DepartmentAttendanceTable({super.key});

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
          const Text('Department Attendance Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

          const SizedBox(height: 24),

          _header(),

          const Divider(height: 32),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  DepartmentRow(department: 'Engineering', present: 42, late: 3, absent: 1, percentage: '93%'),

                  Divider(),

                  DepartmentRow(department: 'Human Resources', present: 12, late: 1, absent: 0, percentage: '96%'),

                  Divider(),

                  DepartmentRow(department: 'Marketing', present: 18, late: 2, absent: 1, percentage: '89%'),

                  Divider(),

                  DepartmentRow(department: 'Finance', present: 15, late: 0, absent: 0, percentage: '100%'),

                  Divider(),

                  DepartmentRow(department: 'Operations', present: 37, late: 4, absent: 2, percentage: '86%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return const Row(
      children: [
        Expanded(
          flex: 3,
          child: Text('Department', style: TextStyle(fontWeight: FontWeight.w600)),
        ),

        Expanded(
          child: Text('Present', style: TextStyle(fontWeight: FontWeight.w600)),
        ),

        Expanded(
          child: Text('Late', style: TextStyle(fontWeight: FontWeight.w600)),
        ),

        Expanded(
          child: Text('Absent', style: TextStyle(fontWeight: FontWeight.w600)),
        ),

        Expanded(
          child: Text('Rate', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class DepartmentRow extends StatelessWidget {
  final String department;
  final int present;
  final int late;
  final int absent;
  final String percentage;

  const DepartmentRow({super.key, required this.department, required this.present, required this.late, required this.absent, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(department, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),

          Expanded(child: Text('$present')),

          Expanded(child: Text('$late')),

          Expanded(child: Text('$absent')),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
              child: Text(
                percentage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
