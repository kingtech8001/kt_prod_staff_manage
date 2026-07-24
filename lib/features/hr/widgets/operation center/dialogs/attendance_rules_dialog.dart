import 'package:flutter/material.dart';

import '../../../../../core/widgets/confirmation_dialog.dart';
import '../../../../../core/widgets/snackbar.dart';

class AttendanceRulesDialog extends StatelessWidget {
  const AttendanceRulesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 700,
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
                    "Attendance Rules",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    _showRuleEditor(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Rule"),
                ),

                const SizedBox(width: 10),

                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: const [
                  RuleTile(title: "Office Start Time", value: "09:00 AM"),

                  Divider(),

                  RuleTile(title: "Grace Period", value: "15 Minutes"),

                  Divider(),

                  RuleTile(title: "Required Working Hours", value: "8 Hours"),

                  Divider(),

                  RuleTile(title: "Lunch Break", value: "60 Minutes"),

                  Divider(),

                  RuleTile(title: "Minimum Overtime", value: "2 Hours"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RuleTile extends StatelessWidget {
  final String title;
  final String value;

  const RuleTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
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

                Text(value, style: const TextStyle(color: Color(0xFF64748B))),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              _showRuleEditor(context, title: title, value: value);
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

void _showRuleEditor(BuildContext context, {String? title, String? value}) {
  final titleController = TextEditingController(text: title ?? '');

  final valueController = TextEditingController(text: value ?? '');

  final isEditing = title != null;

  showDialog(
    context: context,
    builder: (_) {
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
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.rule),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? "Edit Rule" : "Add Rule",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          isEditing
                              ? "Modify attendance policy."
                              : "Create a new attendance rule.",
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

              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Rule Name",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Grace Period",
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Rule Value",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: valueController,
                decoration: InputDecoration(
                  hintText: "15 Minutes",
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(isEditing ? Icons.save : Icons.add),
                  label: Text(isEditing ? "Save Changes" : "Add Rule"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => ConfirmationDialog(
                        title: isEditing ? "Save Rule?" : "Add Rule?",
                        message: isEditing
                            ? "The attendance rule will be updated."
                            : "The new attendance rule will be added.",
                        confirmText: isEditing ? "Save" : "Add",
                        confirmColor: Colors.black,
                        onConfirm: () {
                          Navigator.pop(context);

                          Navigator.pop(context);

                          isEditing
                              ? CommonSnackbar.success(
                                  "Rule Updated",
                                  "Attendance rule updated successfully.",
                                )
                              : CommonSnackbar.success(
                                  "Rule Added",
                                  "Attendance rule added successfully.",
                                );
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
}
