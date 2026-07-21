import 'package:flutter/material.dart';

class EmployeeSearchTile extends StatelessWidget {
  final Map<String, dynamic> employee;
  final VoidCallback onTap;

  const EmployeeSearchTile({
    super.key,
    required this.employee,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFE2E8F0),
              foregroundColor: const Color(0xFF334155),
              child: Text(
                employee['full_name']
                    .toString()
                    .split(' ')
                    .map((e) => e[0])
                    .take(2)
                    .join(),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee['full_name'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    employee['designation'] ?? '',
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }
}
