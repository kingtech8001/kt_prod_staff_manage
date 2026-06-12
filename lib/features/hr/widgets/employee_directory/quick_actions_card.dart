import 'package:flutter/material.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

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
          const Text('Quick Actions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: const Text('Add Employee'),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: const Text('Import Employees'),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: const Text('Export Employees'),
            ),
          ),
        ],
      ),
    );
  }
}
