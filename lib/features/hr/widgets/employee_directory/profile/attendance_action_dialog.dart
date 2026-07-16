import 'package:flutter/material.dart';

import '../../../../../core/utils/date_formatter.dart';

class AttendanceActionDialog extends StatefulWidget {
  final String title;
  final Future<void> Function(
    DateTime date,
    TimeOfDay? punchIn,
    TimeOfDay? punchOut,
  )
  onConfirm;
  final bool showTimePicker;

  const AttendanceActionDialog({
    super.key,
    required this.title,
    required this.onConfirm,
    required this.showTimePicker,
  });

  @override
  State<AttendanceActionDialog> createState() => _AttendanceActionDialogState();
}

class _AttendanceActionDialogState extends State<AttendanceActionDialog> {
  late DateTime selectedDate;
  late TimeOfDay punchIn;
  late TimeOfDay punchOut;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();

    punchIn = const TimeOfDay(hour: 9, minute: 0);
    punchOut = const TimeOfDay(hour: 18, minute: 0);
  }

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
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Select the attendance date you want to update.',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
            ),

            const SizedBox(height: 24),

            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),

                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFF0B1633),
                          onPrimary: Colors.white,
                          surface: Colors.white,
                          onSurface: Color(0xFF111827),
                        ),

                        dialogTheme: DialogThemeData(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),

                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF0B1633),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  color: const Color(0xFFF8FAFC),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xFF475569),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        DateFormatter.formatDate(
                          selectedDate.toIso8601String(),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _timePicker(
                    title: "Punch In",
                    value: punchIn,
                    onChanged: (time) {
                      setState(() {
                        punchIn = time;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _timePicker(
                    title: "Punch Out",
                    value: punchOut,
                    onChanged: (time) {
                      setState(() {
                        punchOut = time;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            if (widget.showTimePicker) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(110, 46),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),

                  const SizedBox(width: 12),

                  ElevatedButton(
                    onPressed: () async {
                      await widget.onConfirm(
                        selectedDate,
                        widget.showTimePicker ? punchIn : null,
                        widget.showTimePicker ? punchOut : null,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(140, 46),
                      backgroundColor: const Color(0xFF0B1633),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(widget.title),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _timePicker({
    required String title,
    required TimeOfDay value,
    required Function(TimeOfDay) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 8),

        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: value,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF0B1633), // dark navy
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Color(0xFF111827),
                    ),

                    timePickerTheme: TimePickerThemeData(
                      backgroundColor: Colors.white,
                      hourMinuteColor: Color(0xFFF8FAFC),
                      hourMinuteTextColor: Color(0xFF111827),
                      dayPeriodColor: Color(0xFFF8FAFC),
                      dayPeriodTextColor: Color(0xFF111827),
                      dialBackgroundColor: Color(0xFFF8FAFC),
                      dialHandColor: Color(0xFF0B1633),
                      dialTextColor: WidgetStateColor.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.white;
                        }
                        return const Color(0xFF111827);
                      }),
                      entryModeIconColor: Color(0xFF0B1633),

                      dialTextStyle: const TextStyle(
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w500,
                      ),

                      hourMinuteTextStyle: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 56,
                        fontWeight: FontWeight.w400,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              onChanged(picked);
            }
          },

          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time),

                const SizedBox(width: 10),

                Text(
                  value.format(context),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
