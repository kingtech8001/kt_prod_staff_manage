import 'package:flutter/material.dart';

class EmployeeListCard extends StatelessWidget {
  const EmployeeListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = [
      {'name': 'Alex Rivera', 'role': 'Senior Product Designer', 'department': 'Design', 'status': 'Present'},
      {'name': 'Bethany Chen', 'role': 'Software Engineer', 'department': 'Engineering', 'status': 'Late'},
      {'name': 'Carlos Mendez', 'role': 'HR Manager', 'department': 'People', 'status': 'Present'},
      {'name': 'Diana Prince', 'role': 'Marketing Lead', 'department': 'Marketing', 'status': 'Leave'},
      {'name': 'Ethan Hunt', 'role': 'Security Analyst', 'department': 'Operations', 'status': 'Present'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: employees.map((employee) => Padding(padding: const EdgeInsets.only(bottom: 16), child: _EmployeeTile(employee))).toList(),
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  final Map employee;

  const _EmployeeTile(this.employee);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundColor: const Color(0xFFE2E8F0), child: Text(employee['name'].toString().split(' ').map((e) => e[0]).take(2).join())),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee['name'], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),

                const SizedBox(height: 4),

                Text('${employee['role']} • ${employee['department']}', style: const TextStyle(color: Color(0xFF64748B))),
              ],
            ),
          ),

          _statusChip(employee['status']),
        ],
      ),
    );
  }

  Widget _statusChip(String status) {
    Color bg;
    Color text;

    switch (status) {
      case 'Late':
        bg = const Color(0xFFFFF4E5);
        text = Colors.orange;
        break;

      case 'Leave':
        bg = const Color(0xFFFFF1F2);
        text = Colors.red;
        break;

      default:
        bg = const Color(0xFFE8F5E9);
        text = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status,
        style: TextStyle(color: text, fontWeight: FontWeight.w600),
      ),
    );
  }
}
