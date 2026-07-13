import 'package:flutter/material.dart';

import '../../../../../core/widgets/confirmation_dialog.dart';
import '../../../../../core/widgets/snackbar.dart';

class HolidayManagementDialog extends StatelessWidget {
  const HolidayManagementDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 650,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Holiday Management",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),

                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    _showHolidayEditor(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Holiday"),
                ),

                const SizedBox(width: 12),

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Divider(),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  return const _HolidayRow(
                    title: "Independence Day",
                    date: "15 August 2026",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HolidayRow extends StatelessWidget {
  final String title;
  final String date;

  const _HolidayRow({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        children: [
          const Icon(Icons.calendar_month_rounded, color: Color(0xFF2563EB)),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(date, style: const TextStyle(color: Color(0xFF64748B))),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              _showHolidayEditor(
                context,
                holidayName: title,
                holidayDate: DateTime(2026, 8, 15),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),

          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ConfirmationDialog(
                  title: "Delete Holiday?",
                  message: "Are you sure you want to delete this holiday?",
                  confirmText: "Delete",
                  confirmColor: Colors.red,
                  onConfirm: () {
                    /// backend later
                  },
                ),
              );
            },
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

void _showHolidayEditor(
  BuildContext context, {
  String? holidayName,
  DateTime? holidayDate,
}) {
  final nameController = TextEditingController(text: holidayName ?? '');

  DateTime? selectedDate = holidayDate;

  final isEditing = holidayName != null;

  showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: 560,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //------------------------------------------------
                  Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing ? "Edit Holiday" : "Add Holiday",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              isEditing
                                  ? "Update holiday information."
                                  : "Create a company holiday.",
                              style: const TextStyle(color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  //-----------------------------------------
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Holiday Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Republic Day",
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  //-----------------------------------------
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Holiday Date",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2035),
                        initialDate: selectedDate ?? DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(
                                  0xFF111827,
                                ), // Selected date / header
                                onPrimary: Colors.white,
                                surface: Colors.white, // Dialog background
                                onSurface: Color(0xFF111827), // Normal text
                              ),
                              dialogTheme: DialogThemeData(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF111827),
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
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              selectedDate == null
                                  ? "Choose Holiday Date"
                                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            ),
                          ),

                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                  //-----------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label: Text(isEditing ? "Save Changes" : "Add Holiday"),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => ConfirmationDialog(
                            title: isEditing
                                ? "Save Holiday Changes?"
                                : "Add New Holiday?",
                            message: isEditing
                                ? "The holiday information will be updated for all employees."
                                : "This holiday will be added to the company calendar.",

                            confirmText: isEditing
                                ? "Save Changes"
                                : "Add Holiday",

                            confirmColor: Colors.black,

                            onConfirm: () {
                              Navigator.pop(context); // confirmation dialog

                              Navigator.pop(context); // editor dialog

                              isEditing
                                  ? CommonSnackbar.success(
                                      "Holiday Deleted",
                                      "The holiday has been removed.",
                                    )
                                  : CommonSnackbar.success(
                                      "Holiday Added",
                                      "The holiday has been added successfully.",
                                    );

                              // TODO:
                              // Call repository later.
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
