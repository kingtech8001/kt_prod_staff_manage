import 'package:flutter/material.dart';

class HrActionsCard extends StatelessWidget {
  const HrActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HR Actions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: Row(mainAxisAlignment: .center, children: [Icon(Icons.check), SizedBox(width: 5), const Text('Mark Present')]),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: Row(mainAxisAlignment: .center, children: [Icon(Icons.close), SizedBox(width: 5), const Text('Mark Absent')]),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: Row(mainAxisAlignment: .center, children: [Icon(Icons.check), SizedBox(width: 5), const Text('Approve Leave')]),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black), foregroundColor: WidgetStatePropertyAll(Colors.white)),
              child: Row(mainAxisAlignment: .center, children: [Icon(Icons.close), SizedBox(width: 5), const Text('Reject Leave')]),
            ),
          ),
        ],
      ),
    );
  }
}
