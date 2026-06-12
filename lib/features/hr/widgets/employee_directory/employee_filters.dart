import 'package:flutter/material.dart';

class EmployeeFilters extends StatelessWidget {
  const EmployeeFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('All Staff', true),
        const SizedBox(width: 12),

        _chip('Engineering', false),
        const SizedBox(width: 12),

        _chip('HR', false),
        const SizedBox(width: 12),

        _chip('Operations', false),

        const Spacer(),

        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
          label: const Text('Add Employee'),
        ),
      ],
    );
  }

  Widget _chip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0B1633) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(text, style: TextStyle(color: selected ? Colors.white : const Color(0xFF0F172A))),
    );
  }
}
