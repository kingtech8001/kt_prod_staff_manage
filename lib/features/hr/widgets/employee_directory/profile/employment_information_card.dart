import 'package:flutter/material.dart';

class EmploymentInformationCard extends StatelessWidget {
  const EmploymentInformationCard({super.key});

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
          const Text('Employment Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

          const SizedBox(height: 24),

          _infoRow('Employee ID', 'EMP-2026-001'),

          _infoRow('Employment Status', 'Active'),

          _infoRow('Employment Type', 'Full-Time'),

          _infoRow('Department', 'Engineering'),

          _infoRow('Manager', 'Sarah Wilson'),

          _infoRow('Office Location', 'London HQ'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Color(0xFF64748B))),
          ),

          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
