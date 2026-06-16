import 'package:flutter/material.dart';

import '../../../../../core/utils/date_formatter.dart';

class AttendanceActionDialog extends StatefulWidget {
  final String title;
  final Future<void> Function(DateTime date) onConfirm;

  const AttendanceActionDialog({super.key, required this.title, required this.onConfirm});

  @override
  State<AttendanceActionDialog> createState() => _AttendanceActionDialogState();
}

class _AttendanceActionDialogState extends State<AttendanceActionDialog> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 480,
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
              widget.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
            ),

            const SizedBox(height: 8),

            const Text('Select the attendance date you want to update.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),

            const SizedBox(height: 24),

            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),

                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(primary: Color(0xFF0B1633), onPrimary: Colors.white, surface: Colors.white, onSurface: Color(0xFF111827)),

                        dialogTheme: DialogThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),

                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF0B1633),
                            textStyle: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),

                      child: child!,
                    );
                  },
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  color: const Color(0xFFF8FAFC),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, color: Color(0xFF475569)),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        selectedDate == null ? 'Choose Attendance Date' : DateFormatter.formatDate(selectedDate!.toIso8601String()),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: selectedDate == null ? FontWeight.w400 : FontWeight.w600,
                          color: selectedDate == null ? const Color(0xFF94A3B8) : const Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(110, 46),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cancel'),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: selectedDate == null
                      ? null
                      : () async {
                          await widget.onConfirm(selectedDate!);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 46),
                    backgroundColor: const Color(0xFF0B1633),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text(widget.title),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
