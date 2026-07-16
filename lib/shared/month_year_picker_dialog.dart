import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;

  const MonthYearPickerDialog({super.key, required this.initialDate});

  @override
  State<MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();

    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 520,
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
            const Text(
              "Select Month",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),

            const Text(
              "Choose the month and year.",
              style: TextStyle(color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 28),

            const Text("Year", style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  dropdownColor: Colors.white,
                  value: selectedYear,
                  isExpanded: true,

                  items: List.generate(currentYear - 2019, (index) {
                    final year = currentYear - index;

                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),

                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedYear = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text("Month", style: TextStyle(fontWeight: FontWeight.w600)),

            const SizedBox(height: 14),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: 12,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),

              itemBuilder: (_, index) {
                final month = index + 1;

                final selected = month == selectedMonth;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),

                  onTap: () {
                    setState(() {
                      selectedMonth = month;
                    });
                  },

                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),

                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF0B1633)
                          : const Color(0xFFF8FAFC),

                      borderRadius: BorderRadius.circular(14),

                      border: Border.all(
                        color: selected
                            ? const Color(0xFF0B1633)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),

                    child: Center(
                      child: Text(
                        DateFormat.MMM().format(DateTime(2024, month)),

                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(0xFF111827),

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

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

                  child: const Text("Cancel"),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,

                      DateTime(selectedYear, selectedMonth),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1633),

                    foregroundColor: Colors.white,

                    minimumSize: const Size(120, 46),

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text("Apply"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
