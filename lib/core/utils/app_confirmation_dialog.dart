import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/auth/controller/leave_controller.dart';
import '../widgets/snackbar.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final Color confirmColor;

  const AppConfirmationDialog({super.key, required this.title, required this.message, required this.confirmText, required this.confirmColor});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
            ),

            const SizedBox(height: 12),

            Text(message, style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF64748B))),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(110, 48),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(130, 48),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => Get.back(result: true),
                  child: Text(confirmText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveRequestDialog extends StatefulWidget {
  const LeaveRequestDialog({super.key});

  @override
  State<LeaveRequestDialog> createState() => _LeaveRequestDialogState();
}

class _LeaveRequestDialogState extends State<LeaveRequestDialog> {
  final controller = Get.find<LeaveController>();

  final reasonController = TextEditingController();

  String leaveType = 'Annual';

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Request Leave', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),

            const SizedBox(height: 24),

            DropdownButtonFormField<String>(
              value: leaveType,
              decoration: const InputDecoration(labelText: 'Leave Type', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'Annual', child: Text('Annual Leave')),
                DropdownMenuItem(value: 'Sick', child: Text('Sick Leave')),
                DropdownMenuItem(value: 'Casual', child: Text('Casual Leave')),
              ],
              onChanged: (value) {
                leaveType = value!;
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2030), initialDate: DateTime.now());

                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                        });
                      }
                    },
                    child: Text(startDate == null ? 'Start Date' : '${startDate!.day}/${startDate!.month}/${startDate!.year}'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: startDate ?? DateTime.now(),
                        lastDate: DateTime(2030),
                        initialDate: startDate ?? DateTime.now(),
                      );

                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    child: Text(endDate == null ? 'End Date' : '${endDate!.day}/${endDate!.month}/${endDate!.year}'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(onPressed: () => Get.back(), child: const Text('Cancel')),

                const SizedBox(width: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B1633), foregroundColor: Colors.white),
                  onPressed: () async {
                    if (startDate == null || endDate == null) {
                      CommonSnackbar.warning('Validation', 'Please select dates');
                      return;
                    }

                    await controller.applyLeave(leaveType: leaveType, startDate: startDate!, endDate: endDate!, reason: reasonController.text.trim());

                    Get.back();
                  },
                  child: const Text('Submit Request'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
